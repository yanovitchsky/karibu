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
    include ::Celluloid

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
        # @instance = self.new(@addr)
        # @instance.async.launch_queue
      end

      def const_missing(kl)
        raise "You should define a connection_string" if @addr.nil?
        xaddr = @addr
        anon_class = Class.new do
          define_singleton_method(:method_missing) do |method_name, *args|
            request = Karibu::ClientRequest.new(kl.to_s, method_name.to_s, args)
            requester = Karibu::Requester.new(xaddr)
            response = requester.call_rpc(request.encode())
            result = Karibu::ClientResponse.new(response).decode
            raise result.error unless result.error.nil?
            result.result
          end
        end
        klass = const_set(kl, anon_class)
      end
    end

    # instance methods

    # def initialize(addr)
    #   @address = addr
    #   # @workers_url = "inproc://Karibu_clients"
    #   @ctx = ::ZMQ::Context.new(1)
    #   @requester = Requester.new(@ctx, @address)
    #   # @queue = Karibu::Queue.new(@ctx, @address, @workers_url, :client)
    # end

    # # def run
    # #   p "client started on #{@address}"
    # #   @queue.async.run
    # #   # pool = Karibu::Requester.pool(size: 10, args: [@ctx, @workers_url])
    # # end

    # def launch_queue
    #   p "client started on #{@address}"
    #   @queue.run
    # end

    # def send_request(request)
    #   # requester = Requester.new(@ctx, @workers_url)
    #   @requester.call_rpc(request.encode())
    # end
  end
end

# class MessageService < Karibu::Service
#   connection_string "tcp:127.0.0.1:8900"
# end

# MessageService.connect


# s = MessageService::Message.future.echo
