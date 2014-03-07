module Karibu
  class Server
    include ::Celluloid

    def initialize(address, routes, numberofthreads)
      @routes = routes
      @address = address
      @workers_url = "inproc://karibu_server"
      @ctx = ::ZMQ::Context.new(1)
      @numberofthreads = numberofthreads
      @queue = Karibu::Queue.supervise_as :queue, @ctx, @address, @workers_url, :server
    end

    def run
      p  "server started on #{@address} with #{@numberofthreads} threads"
      Celluloid::Actor[:queue].async.run
      pool = Karibu::Dispatcher.pool(size: @numberofthreads, args: [@ctx, @workers_url, @routes])
      pool.async.run
    end

    # class GroupSupervisor
    #   supervise Karibu::Queue, as: :queue
    #   pool      Karibu::Dispatcher, as: :dispatcher_pool, 
    # end
  end
end