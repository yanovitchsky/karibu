# this is a simple implemetation of requester with a connectionpool
# does not take server amount of threads in account
module Karibu
  class Requester
    def initialize(url, timeout=nil)
      @timeout = timeout || 30
      @url = url
      @ctx = ::ZMQ::Context.new(1)
      @socket = @ctx.socket(::ZMQ::REQ)
      # @socker
      @socket.connect(url)
    end

    def call_rpc(request)
      p request
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

  class ConnectionRobin
    include Singleton
    attr_accessor :urls, :timeout

    def initialize
      @initiated = false
    end

    def initiated?
      @initiated
    end

    def init(urls, timeout)
      @timeout = timeout
      @urls = (urls.is_a? ::Array) ? urls : [urls]
      @lock = Mutex.new
      @nbr_requester = @urls.size
      @next_requester_index = 0
      @requesters = []
      @pool = nil
      # create_requester()
      @initiated = true
      self
    end

    def get_requester
      @lock.synchronize{
        unless ENV['KARIBU_ENV'] == "production"
          Karibu::LOGGER.async.debug "serve with url #{@urls[@next_requester_index]}"
        end
        requester = Karibu::Requester.new @urls[@next_requester_index], @timeout
        @next_requester_index = (@next_requester_index + 1) % @nbr_requester
        requester
      }
    end

    private
    def create_requester
      @urls.each do |url|
        @requesters << Karibu::Requester.new(url, @timeout)
      end
    end
  end
end
