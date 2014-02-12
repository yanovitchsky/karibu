module Karibu
  class Dispatcher
    include ::Celluloid

    def initialize(ctx, url)
      @socket = ctx.socket(::ZMQ::REP)
      @socket.connect(url)
    end

    def process_request(msg)
      request = Karibu::Request.new(msg)
      begin
        klass = Kernel.const_get(request.resource.capitalize)
        meth = request.method_called.to_sym
        result = klass.send(meth, *request.params)
        response = Karibu::Response.new(1, request.uniq_id, nil, [result])
      rescue NameError => e
      
      rescue Karibu::Errors::ServiceResourceNotFound => e
         e
      rescue Karibu::Errors::MethodNotFound => e
        e
      rescue Error => e
        e
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