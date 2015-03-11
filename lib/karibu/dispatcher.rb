module Karibu
  class Dispatcher
    include ::Celluloid

    def initialize(ctx, url, routes, options)
      @routes = routes
      @socket = ctx.socket(::ZMQ::REP)
      @socket.connect(url)
      # Karibu::LOGGER = Karibu::Logger.new
      @timeout = options[:timeout]
      @app = options[:app]
    end

    def process_request(msg)
      begin_t = Time.now
      request = Karibu::ServerRequest.new(msg).decode()
      Karibu::LOGGER.async.info request.to_s
      begin
        Timeout::timeout(@timeout){
          response = exec_request(request)
          # response = @app.call(request)
          Karibu::LOGGER.async.info "#{response.to_s} in #{Time.now - begin_t}"
          response
        }
      rescue => e
        begin
          print_backtrace(e) if ENV['KARIBU_ENV'] == 'development'
          server_exception = Karibu::ErrorHandler.new(e) # find karibu error based on execution error
          raise server_exception.error
        rescue => e
          # rescue and send error to client based on name
          error = {klass: e.class.to_s.split('::').last, msg: e.to_s}
          response = Karibu::ServerResponse.new(1, request.uniq_id, error, nil)
          Karibu::LOGGER.async.error "#{response.to_s} in #{Time.now - begin_t}"
          return response
        end
      end
    end

    def exec_request(request)
      klass = Kernel.const_get(request.resource)
      meth = request.method_called.to_sym
      check_route(klass, meth)
      result = @app.call(request)
      # result = klass.send(meth, *request.params)
      Karibu::ServerResponse.new(1, request.uniq_id, nil, result)
    end

    def run
      loop do
        buff = ""
        @socket.recv_string(buff)
        t = Time.now
        response = process_request(buff)
        @socket.send_string(response.encode(), 0)
      end
    end

    private
    def check_route(klass, meth)
      raise Karibu::Errors::ServiceResourceNotFoundError.new("#{klass} does not exist") unless @routes.has_key?(klass)
      raise Karibu::Errors::MethodNotFoundError.new("resource #{klass} has no method #{meth}") unless @routes[klass].include? meth
    end

    def print_backtrace e
      $stderr.puts (e.backtrace * "\n")      
    end
  end
end