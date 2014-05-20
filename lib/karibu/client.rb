module Karibu

  class Requester
    def initialize(url)
      @ctx = ::ZMQ::Context.new(1)
      @socket = @ctx.socket(::ZMQ::REQ)
      @socket.connect(url)
    end

    def call_rpc(request)
      @socket.send_string(request, 0)
      buff = ""
      @socket.recv_string(buff)
      @socket.close
      return buff
    end
  end

  class Client
    ## Class Method
    class << self
      attr_accessor :addr, :instance

      def connection_string cs
        @addr = cs
      end

      def addr
        @addr
      end

      def connect
        raise "You should define a connection_string" if @addr.nil?
      end

      def const_missing(kl)
        raise "You should define a connection_string" if @addr.nil?
        xaddr = @addr
        anon_class = Class.new do
          define_singleton_method(:method_missing) do |method_name, *args|
            # begin
              request = Karibu::ClientRequest.new(kl.to_s, method_name.to_s, args)
              requester = Karibu::Requester.new(xaddr)
              response = requester.call_rpc(request.encode())
              result = Karibu::ClientResponse.new(response).decode
              unless result.error.nil?
                raise Karibu::Errors.const_get(result.error['klass']).new(result.error['msg'])
              else 
                result.result
              end
            # rescue => e
            #   raise Karibu::Errors::ClientError.new(e.to_s)
            # end
          end
        end
        klass = const_set(kl, anon_class)
      end
    end
  end
end

