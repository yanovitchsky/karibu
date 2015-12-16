module Karibu
  class Server
    include ::Celluloid

    def initialize(address, routes, numberofthreads, options)
      @options = options
      @routes = routes
      @address = address
      @workers_url = "inproc://karibu_server"
      @ctx = ::ZMQ::Context.new(1)
      @numberofthreads = numberofthreads
      # @queue = Karibu::Queue.supervise_as :queue, @ctx, @address, @workers_url, :server
      @queue = Karibu::Queue.supervise(
        as: :queue,
        args: [@ctx, @address, @workers_url, :server]
      )
    end

    def run
      Karibu::LOGGER.async.info "#{ENV['KARIBU_ENV']} server started on #{@address} with #{@numberofthreads} threads"
      Celluloid::Actor[:queue].async.run
      pool = Karibu::Dispatcher.pool(size: @numberofthreads, args: [@ctx, @workers_url, @routes, @options])
      @numberofthreads.times { pool.async.run}
    end

    # class GroupSupervisor
    #   supervise Karibu::Queue, as: :queue
    #   pool      Karibu::Dispatcher, as: :dispatcher_pool,
    # end
  end
end
