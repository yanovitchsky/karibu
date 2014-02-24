module Karibu
  class Queue
    include ::Celluloid

    def initialize(ctx, frontend_url, backend_url, flag)
      @frontend_url = frontend_url
      @backend_url = backend_url
      if flag == :server
        @frontend = ctx.socket(::ZMQ::ROUTER)
        @backend  = ctx.socket(::ZMQ::DEALER)
      elsif flag == :client
        @frontend = ctx.socket(::ZMQ::DEALER)
        @backend  = ctx.socket(::ZMQ::ROUTER)
      else
        raise "flag should be  either :client or :server"
      end
    end

    def run
      p "runing queue"
      @frontend.bind(@frontend_url)
      @backend.bind(@backend_url)
      device = ::ZMQ::Device.new(@frontend,@backend)
    end
  end
end