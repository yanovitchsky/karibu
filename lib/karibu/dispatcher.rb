module Karibu
  class Dispatcher
    include ::Celluloid

    def initialize(ctx, url, routes)
      @routes = routes
      @socket = ctx.socket(::ZMQ::REP)
      @socket.connect(url)
      @logger = Karibu::Logger.new
    end

    def process_request(msg)
      begin_t = Time.now
      request = Karibu::ServerRequest.new(msg).decode()
      @logger.async.info request.to_s
      begin
        klass = Kernel.const_get(request.resource.capitalize)
        meth = request.method_called.to_sym
        raise Karibu::Errors::ServiceResourceNotFound unless @routes.has_key?(klass)
        raise Karibu::Errors::MethodNotFound unless @routes[klass] == meth
        result = klass.send(meth, *request.params)
        response = Karibu::ServerResponse.new(1, request.uniq_id, nil, result)
        @logger.async.info "#{response.to_s} in #{Time.now - begin_t}"
        return response
      rescue Exception => e  
        response = Karibu::ServerResponse.new(1, request.uniq_id, e.to_s, nil)
        @logger.async.error "#{response.to_s} in #{Time.now - begin_t}"
        return response
      end
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
  end
end