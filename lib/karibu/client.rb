require 'connection_pool'
module Karibu


  # class ClientQueue
  #   include Singleton
  #   # attr_accessor :pool
  #   # def initialize
  #   #   # @pool = ::ConnectionPool.new(size: 1) { 
  #   #     ctx = ::ZMQ::Context.new(1)
  #   #     @socket = ctx.socket(::ZMQ::REQ)
  #   #   # }
  #   # end
  #   # def execute(url, timeout, request)
  #   #   # res = @pool.with do |socket|
  #   #     p @socket
  #   #     Timeout::timeout(timeout){
  #   #       @socket.connect(url)
  #   #       @socket.send_string(request, 0)
  #   #       buff = ""
  #   #       @socket.recv_string(buff)
  #   #       @socket.close
  #   #       return buff
  #   #     }
  #   #   # end
  #   # end

  #   def initialize(url)
  #     backend_url = url
  #     frontend_url = "inproc://karibu_client"
  #     ctx = ::ZMQ::Context.new(1)
  #     @queue = Karibu::Queue.new(ctx, frontend_url, backend_url, :server)
  #   end

  #   def execute(timeout, request)
      
  #   end
  # end

  class Requester
    def initialize(url, timeout=nil)
      @timeout = timeout || 30
      @url = url
      @ctx = ::ZMQ::Context.new(1)
      @socket = @ctx.socket(::ZMQ::REQ)
      @socker
      @socket.connect(url)
    end

    def call_rpc(request)
      Timeout::timeout(@timeout){
         @socket.send_string(request, 0)
        # evts = @poller.poll(@timeout * 1000)
        # raise Karibu::Errors::CustomError("cannot reach server for #{timeout}") if evts.size == 0
        buff = ""
        @socket.recv_string(buff)
        @socket.close
        @ctx.terminate
        return buff
      }
      # ClientPool.new.execute(@url, @timeout, request)
    end
  end

  
  class Client
    ## Class Method
    class << self
      attr_accessor :addr, :instance, :timeout

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

      def connect
        raise "You should define a connection_string" if @addr.nil?
      end

      def execute(xaddr, timeout, klass, method_name, args)
        begin
          request = Karibu::ClientRequest.new(klass.to_s, method_name.to_s, args)
          requester = Karibu::Requester.new(xaddr, timeout)
          response = requester.call_rpc(request.encode())
          result = Karibu::ClientResponse.new(response).decode
          unless result.error.nil?
            raise Karibu::Errors.const_get(result.error[:klass]).new(result.error[:msg])
          else 
            result.result
          end
        rescue Timeout::Error => e
          raise Karibu::Errors::TimeoutError.new("request has timeout. Cannot reach server")
        end
      end


      def const_missing(kl)
        raise "You should define a connection_string" if @addr.nil?
        xaddr = @addr
        timeout = @timeout
        anon_class = Class.new do
          define_singleton_method(:method_missing) do |method_name, *args|
            Karibu::Client.execute(xaddr, timeout, kl.to_s, method_name, args)
          end
        end
        klass = const_set(kl, anon_class)
      end

      # def const_missing(klass)
      #   puts "in const missing"
      #   raise "You should define a connection_string" if @addr.nil?
      #   xaddr = @addr
      #   timeout = @timeout
      #   new_klass = Class.new do
      #     def self.create_method(method_name, *args)
      #       p "creating method #{method_name}"
      #       self.define_singleton_method(method_name) do |*args|
      #         begin
      #           request = Karibu::ClientRequest.new(klass.to_s, method_name.to_s, args)
      #           requester = Karibu::Requester.new(xaddr, timeout)
      #           response = requester.call_rpc(request.encode())
      #           result = Karibu::ClientResponse.new(response).decode
      #           unless result.error.nil?
      #             raise Karibu::Errors.const_get(result.error[:klass]).new(result.error[:msg])
      #           else 
      #             result.result
      #           end
      #         rescue Timeout::Error => e
      #           raise Karibu::Errors::TimeoutError.new("request has timeout. Cannot reach server")
      #         end
      #       end
      #       self.send(method_name, *args)
      #     end
      #     def self.method_missing(method_name, *args)
      #       p "method #{method_name} is missing"
      #       self.create_method(method_name, args)
      #     end
      #   end

          # define_singleton_method(:method_missing) do |method_name, *args|
          #   self.define_method(method_name, *args) do
          #     p "defining #{method_name}"
          #   end
            # begin
            #   request = Karibu::ClientRequest.new(kl.to_s, method_name.to_s, args)
            #   requester = Karibu::Requester.new(xaddr, timeout)
            #   response = requester.call_rpc(request.encode())
            #   result = Karibu::ClientResponse.new(response).decode
            #   unless result.error.nil?
            #     raise Karibu::Errors.const_get(result.error[:klass]).new(result.error[:msg])
            #   else 
            #     result.result
            #   end
            # rescue Timeout::Error => e
            #   raise Karibu::Errors::TimeoutError.new("request has timeout. Cannot reach server")
            # end
          # end
        # end
      #   self.const_set(klass, new_klass)
      # end
    end
  end
end

