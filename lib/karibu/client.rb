require 'connection_pool'
module Karibu
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
          # time = Time.now
          response = requester.call_rpc(request.encode())
          # p "TIME TAKEN FOR NETWORK---------------"
          # p "#{(Time.now - time) * 1000}"
          # p "--------------------------"
          # time = Time.now
          result = Karibu::ClientResponse.new(response).decode
          # p "TIME TAKEN FOR DECODING ---------------"
          # p "#{(Time.now - time) * 1000}"
          # p "--------------------------"
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
            resp = Karibu::Client.execute(xaddr, timeout, kl.to_s, method_name, args)
            resp
          end

          define_singleton_method(:async) do |method_name, *args|
            
          end
        end
        klass = const_set(kl, anon_class)
      end
    end
  end
end

