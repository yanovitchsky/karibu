module Karibu
  class Server
    include ::Celluloid

    def initialize(address)
      @address = address
      @workers_url = "inproc://workers"
      @ctx = ::ZMQ::Context.new(1)
      @queue = Karibu::Queue.new(@ctx, @address, @workers_url)
    end

    def run
      p  "server started on #{@address}"
      @queue.async.run
      pool = Karibu::Dispatcher.pool(size: 10, args: [@ctx, @workers_url])
      (0..10).each do
        pool.async.run
      end
    end
  end
end