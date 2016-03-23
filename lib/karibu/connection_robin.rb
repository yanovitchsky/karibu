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
    # attr_accessor :urls, :timeout
    attr_accessor :services

    def initialize
      @services = {}
      @initiated = false
    end

    def initiated?
      @initiated
    end

    def init(service_name, urls, timeout)
      unless @services[service_name]
        queue = ::Queue.new
        opts_urls = (urls.is_a? ::Array) ? urls : [urls]
        # fill queue
        opts_urls.each {|url| queue << url}

        service_opts = {
          urls: opts_urls,
          timeout: timeout,
          lock: ::Mutex.new,
          url_queue: queue # filled queue
        }
        @services[service_name] = service_opts
      end
      self
    end

    def get_requester(service_name)
      service = @services[service_name]
      raise "Unkown service #{service_name}" if service.nil?
      url = nil
      lock = service[:lock]
      lock.synchronize do
        url = service[:url_queue].pop(true)
        # if queue empty refill
        if service[:url_queue].size == 0
          service[:urls].each {|url| service[:url_queue] << url}
        end
      end
      timeout = service[:timeout]
      unless ENV['KARIBU_ENV'] == "production"
        Karibu::LOGGER.async.debug "serve with url #{url}"
      end
      return Karibu::Requester.new url, timeout
    end
  end
end
