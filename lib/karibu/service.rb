module Karibu
  class Service
    include ::Celluloid
    #class
    class << self
      attr_accessor :addr, :routes, :server, :numberofthreads, :options, :timeout, :middleware, :__children__
      def connection_string cs
        @addr = cs
      end

      def expose route_string
        begin
          @routes ||= {}
          klass, meth = route_string.split('#')
          the_klass = Kernel.const_get(klass)
          the_meth = meth.to_sym
          check_route(the_klass, the_meth)
          unless @routes.has_key?(the_klass)
            @routes[the_klass] = [the_meth]
          else
            @routes[the_klass] << the_meth
          end
        rescue Exception => e
          raise Karibu::Errors::MethodNotFoundError
        end
      end

      def threads numberofthreads
        @numberofthreads = (numberofthreads < 2) ? 2 : ( (numberofthreads > 100) ? 100 : numberofthreads )
      end

      def response_timeout timeout
        @timeout = timeout
      end

      def start
        raise "You should define a connection_string" if @addr.nil?
#        Celluloid::ZMQ.init
        @routes.freeze
        app = init_middlewares
        self.new(app)
      end

      def use name, *args, &block
        @middlewares ||= []
        @middlewares << Proc.new{|app| name.new(app, *args, &block)}
      end

      def inherited(subclass)
        @__children__ ||= []
        @__children__ << subclass
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

  end
end
