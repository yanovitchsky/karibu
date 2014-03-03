module Karibu
  class Dispatcher
    include ::Celluloid

    def initialize(ctx, url, routes)
      @routes = routes
      @socket = ctx.socket(::ZMQ::REP)
      @socket.connect(url)
    end

    def process_request(msg)
      request = Karibu::ServerRequest.new(msg).decode()
      begin
        klass = Kernel.const_get(request.resource.capitalize) rescue (raise Karibu::Errors::ServiceResourceNotFound)
        meth = request.method_called.to_sym
        raise Karibu::Errors::ServiceResourceNotFound unless @routes.has_key?(klass)
        raise Karibu::Errors::MethodNotFound unless @routes[klass] == meth
        result = klass.send(meth, *request.params)
        response = Karibu::ServerResponse.new(1, request.uniq_id, nil, result)
      rescue Exception => e  
        response = Karibu::ServerResponse.new(1, request.uniq_id, e.to_s, nil)
      end
    end

    def run
      loop do
        buff = ""
        @socket.recv_string(buff)
        response = process_request(buff)
        @socket.send_string(response.encode(), 0)
      end
    end
  end
end