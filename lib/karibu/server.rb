module Karibu
  class Server
    include Celluloid::ZMQ

    def initialize(address, routes)
      @socket = RouterSocket.new
      @full_msg = []
      @clients = []
      @routes = routes
      begin
        @socket.bind(address)
      rescue IOError
        @socket.close
        raise
      end
    end

    def run
      p "server started"
      loop { async.handle_message @socket.read }
    end

    def handle_message(message)
      puts "got message: #{message}"
      format_message message
    end

    def format_message(msg)
      unless msg.empty?
        @full_msg << msg
        if @full_msg.size == 2
          @clients << @full_msg[0] 
          exec_request(@full_msg[0], @full_msg[1])
          @full_msg = []
        end
        # if @full_msg.size == 1
        #   exec_request(nil, @full_msg[0])
        # end
      end
    end

    def exec_request(identity, msg)
      # p msg
      # request = Karibu::Request.new(msg)
      # klass = Kernel.const_get(request.resource)
      # meth  = request.method_called
      # params = request.params
      # klass.send(meth, *params)
      request = Karibu::Request.new(identity, msg)
      p request
      dispatch(request)
    end

    def dispatch(request)
      begin
        klass = Kernel.const_get(request.resource.capitalize)
        meth = request.method_called.to_sym
        result = klass.new.send(meth, *request.params)
        response = Karibu::Response.new(request.identity, 1, request.uniq_id, nil, [result])
        p response
        send_to_client(response)
      rescue NameError => e
        p e
      rescue Karibu::Errors::ServiceResourceNotFound => e
         p e
      rescue Karibu::Errors::MethodNotFound => e
        p e
      rescue Error => e
        p e
      end
    end

    def send_to_client response
      p response.identity
      s = @socket.send(response.identity)
      # p s
      @socket.send("")
      s = @socket.send(response.encode())
      # p s
    end
  end
end