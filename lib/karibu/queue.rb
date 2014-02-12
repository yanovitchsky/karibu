module Karibu
  class Queue
    include ::Celluloid

    def initialize(ctx, frontend_url, backend_url)
      @frontend_url = frontend_url
      @backend_url = backend_url
      @frontend = ctx.socket(::ZMQ::ROUTER)
      @backend  = ctx.socket(::ZMQ::DEALER)
    end

    def run
      p "runing queue"
      @frontend.bind(@frontend_url)
      @backend.bind(@backend_url)
      device = ::ZMQ::Device.new(@frontend,@backend)
    end
  end
end