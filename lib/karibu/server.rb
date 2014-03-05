module Karibu
  class Server
    include ::Celluloid

    def initialize(address, routes)
      @routes = routes
      @address = address
      @workers_url = "inproc://karibu_server"
      @ctx = ::ZMQ::Context.new(1)
      @queue = Karibu::Queue.new(@ctx, @address, @workers_url, :server)
    end

    def run
      p  "server started on #{@address}"
      @queue.async.run
      pool_size = 10
      pool = Karibu::Dispatcher.pool(size: pool_size, args: [@ctx, @workers_url, @routes])
      pool_size.times do
        pool.async.run
      end
    end
  end
end