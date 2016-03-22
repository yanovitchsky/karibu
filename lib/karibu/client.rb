require 'connection_pool'

module Karibu

  class ErrorHash < Hash
    include ::Hashie::Extensions::MergeInitializer
    include ::Hashie::Extensions::IndifferentAccess
  end

  class Client
    ## Class Method
    class << self
      attr_accessor :addr, :instance, :timeout, :namespaces, :robin

      def connection_string cs
        @addr = cs
        # CONNECTION_STRING = cs
      end

      def addr
        @addr
      end

      def timeout sec
        @timeout = sec
        # TIMEOUT = sec
      end

      def robin
        @robin = ConnectionRobin.instance
      end

      def endpoint namespace
        root_class = self
        root = self
        modules = namespace.split("::")
        # raise modules.inspect
        last = modules.last
        modules.each do |cons|
          unless const_defined?(cons)
            cons_mod = Module.new do
              @root = root_class
            end
            root.const_set cons, cons_mod
            if cons == last
              cons_mod.define_singleton_method(:method_missing) do |method_name, *args|
                service_endpoint = self.to_s.split("#{@root}::").last
                @root.call(service_endpoint, method_name, args)
              end
            end
          end
          # p root.const_get(cons)
          root = root.const_get(cons)
        end
      end

      # sets up response keys symbol
      def symbolize_keys bool
        config = Karibu::ClientConfig.instance
        config.symbolize_keys = bool
      end

      def connect
        raise "You should define a connection_string" if @addr.nil?
      end

      # def execute(xaddr, timeout, klass, method_name, args)
      def execute(robin, klass, method_name, args)
        begin
          # p klass
          request = Karibu::ClientRequest.new(klass.to_s, method_name.to_s, args)
          # requester = Karibu::Requester.new(robin.urls.first, robin.timeout)
          requester = robin.get_requester
          # p requester
          response = requester.call_rpc(request.encode())
          result = Karibu::ClientResponse.new(response).decode
          unless result.error.nil?
            error_hash = ErrorHash.new result.error
            raise Errors.const_get(error_hash[:klass]).new(error_hash[:msg])
          else
            result.result
          end
        rescue Timeout::Error => e
          raise Karibu::Errors::TimeoutError.new("request has timeout. Cannot reach server")
        end
      end

      def call(mod, method_name, args)
        xaddr = @addr
        timeout = @timeout
        robin_instance = Karibu::Client.robin
        robin = robin_instance.init(xaddr,timeout)
        # resp = Karibu::Client.execute(xaddr, timeout, mod.to_s, method_name, args, robin)
        resp = Karibu::Client.execute(robin, mod.to_s, method_name, args)
        resp
      end


      # def const_missing(kl)
      #   raise kl.inspect
      #   # raise "You should define a connection_string" if @addr.nil?
      #   # xaddr = @addr
      #   # timeout = @timeout
      #   # anon_class = Class.new do
      #   #   define_singleton_method(:method_missing) do |method_name, *args|
      #   #     resp = Karibu::Client.execute(xaddr, timeout, kl.to_s, method_name, args)
      #   #     resp
      #   #   end
      #   # end
      #   # klass = const_set(kl, anon_class)
      # end
    end
  end
end
