module Karibu
  class Service
    include Celluloid
    #class
    class << self
      attr_accessor :addr, :routes, :server
      def connection_string cs
        @addr = cs
      end

      def expose route_string
        begin
          @routes ||= {}
          klass, meth = route_string.split('#')
          the_klass = Kernel.const_get(klass.capitalize)
          the_meth = meth.to_sym
          check_route(the_klass, the_meth)
          @routes[the_klass] = the_meth
        rescue NameError => e
          raise Karibu::Errors::ServiceResourceNotFound
        end
      end

      def start
        Celluloid::ZMQ.init
        @routes.freeze
        self.new()
      end


      private
      def check_route(klass, method)
        raise Karibu::Errors::ServiceResourceNotFound unless defined?(klass)
        raise Karibu::Errors::MethodNotFound unless klass.methods.include?(method)
      end
    end

    # instance 
    # attention on a besoin de l'id de la requete avant de l'envoyer mode zmq async


    def initialize
      @server = Karibu::Server.new(self.class.addr, self.class.routes)
      @server.async.run
    end

    def dispatch(request)
      begin
        p "request in dispatch is #{request}"
        klass = Kernel.const_get(request.resource.capitalize)
        p klass
        meth = request.method_called.to_sym
        result = klass.send(meth, *request.params)
        response = Karibu::Response.new(request.identity, 1, request.uniq_id, nil, [result])
        @server.send_to_client(response)
      rescue NameError => e

      rescue Karibu::Errors::ServiceResourceNotFound => e

      rescue Karibu::Errors::MethodNotFound => e

      rescue Error => e
        
      end
    end
  end
end