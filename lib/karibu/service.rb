module Karibu
  class Service
    include ::Celluloid
    #class
    class << self
      attr_accessor :addr, :routes, :server, :numberofthreads, :options, :timeout, :middleware
      def connection_string cs
        @addr = cs
      end

      def expose route_string, &block
        begin
          @routes ||= {}
          klass, meth = route_string.split('#')
          the_klass = Kernel.const_get(klass)
          the_meth = meth.to_sym
          check_route(the_klass, the_meth)
          @routes[the_klass] = the_meth
          if block_given?
            doc = Karibu::Doc.new(route_string, &block)
          end
        rescue NameError => e
          p e
          raise Karibu::Errors::ServiceResourceNotFoundError
        end
      end

      def threads numberofthreads
        # init_options
        @numberofthreads = (numberofthreads < 2) ? 2 : ( (numberofthreads > 100) ? 100 : numberofthreads )
        # @options[:number_of_threads] = @numberofthreads 
      end

      def response_timeout timeout
        @timeout = timeout     
      end

      def start
        raise "You should define a connection_string" if @addr.nil?
        Celluloid::ZMQ.init
        Karibu::LOGGER ||= Karibu::Logger.new()
        @routes.freeze
        app = init_middlewares
        self.new(app)
      end

      def use name, *args, &block
        # @middlewares ||= []
        # @middlewares.unshift [name, *args, &block]
        # p "IN USE ------------"
        # p "#{@middlewares}"
        # @middlewares = @middlewares.uniq
        @middlewares ||= []
        @middlewares << Proc.new{|app| name.new(app, *args, &block)}
      end


      private
      def check_route(klass, method)
        raise Karibu::Errors::ServiceResourceNotFoundError unless defined?(klass)
        raise Karibu::Errors::MethodNotFoundError unless klass.methods.include?(method)
      end

      def init_options
        @options ||= {}
      end

      def init_middlewares
        app = Karibu::Executor.new()
        @middlewares ||= []
        @middlewares.each do |middleware|
          app = middleware.call(app)
        end
        app
      end

    end

    # instance 
    # attention on a besoin de l'id de la requete avant de l'envoyer mode zmq async


    def initialize(app)
      options = {app: app}
      numberofthreads = self.class.numberofthreads || 10
      options[:timeout] = self.class.timeout || 60
      @server = Karibu::Server.new(self.class.addr, self.class.routes, numberofthreads, options)
      @server.async.run
    end

    # def dispatch(request)
    #   begin
    #     p "request in dispatch is #{request}"
    #     klass = Kernel.const_get(request.resource.capitalize)
    #     p klass
    #     meth = request.method_called.to_sym
    #     result = klass.send(meth, *request.params)
    #     response = Karibu::Response.new(request.identity, 1, request.uniq_id, nil, [result])
    #     @server.send_to_client(response)
    #   rescue NameError => e

    #   rescue Karibu::Errors::ServiceResourceNotFoundError => e

    #   rescue Karibu::Errors::MethodNotFoundError => e

    #   rescue Error => e
        
    #   end
    # end
  end
end