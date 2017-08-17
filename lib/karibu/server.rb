# @author yanovitchsky
module Karibu
  class Server
     include ::Singleton

    # class methods
    class << self

      def start
        self.instance.run!
      end

      def stop
        self.instance.stop
      end
    end


    # Instance Methods
    def initialize
      @config = Karibu::Configuration.configuration
      @worker_pool = Concurrent::ThreadPoolExecutor.new(
        min_threads: @config.workers,
        max_thread: @config.workers + (@config.workers / 2).round,
        max_queue: 100
      )
      @ctx = ::ZMQ::Context.new
      @router = @ctx.socket(ZMQ::ROUTER)
      @running = true
    end

    def run!
      load @config.boot_file
      check_pid
      daemonize if daemonize?
      write_pid
      trap_signals


      @router.bind(connection_string)
      _console_print_
      while @running
        id = ''
        empty = ''
        payload = ''
        @router.recv_string id
        @router.recv_string empty
        @router.recv_string payload
        response = exec!(id, payload)
        @router.send_string(id, ZMQ::SNDMORE)
        @router.send_string("", ZMQ::SNDMORE)
        @router.send_string(response.value)
      end
    end

    def stop
      @running = false
      cleanup
      kill_pid
      exit
    end

    def cleanup
      @router.close
      @ctx.terminate
    end

    def exec! id, request
      Concurrent::Future.execute(executor: @worker_pool) do
        _exec!(request)
        # p "I received a message #{request}"
        # sleep rand(2)
      end
    end

    private

    def _exec!(request)
      begin
        start_watch = Time.now
        payload = Karibu::Request.new(request).decode
        response = Dispatcher.new.process(payload)
        stop_watch = Time.now
        log(payload, start_watch, stop_watch)
        success_response(response, payload)
      rescue StandardError => e
        log_error(e)
        send_to_rollbar(e)
        error_response(e, payload)
      end
    end

    def check_pid
      pidfile = @config.pid_file
      if pidfile?
        case pid_status(pidfile)
        when :running, :not_owned
          puts "A server is already running. Check #{@config.pidfile}"
          exit(1)
        when :dead
          File.delete(pidfile)
        end
      end
    end

    def write_pid
      pidfile = @config.pid_file
      if pidfile?
        begin
          File.open(pidfile, ::File::CREAT | ::File::EXCL | ::File::WRONLY){|f| f.write("#{Process.pid}") }
          at_exit { File.delete(pidfile) if File.exists?(pidfile) }
        rescue Errno::EEXIST
          check_pid
          retry
        end
      end
    end

    def daemonize
      exit if fork
      Process.setsid
      exit if fork
      Dir.chdir "/"
    end

    def kill_pid
      begin
        pid = ::File.read(@config.pid_file).to_i
        Process.kill('QUIT', pid)
      rescue Errno::ESRCH
         # process exited normally
      end
    end

    def pid_status(pidfile)
      begin
        return :exited unless File.exist?(pidfile)
        pid = ::File.read(pidfile).to_i
        return :dead if pid == 0
        Process.kill(0, pid)  # check process status
        :running
      rescue Errno::ESRCH
        :dead
      rescue Errno::EPERM
        :not_owned
      end
    end

    def pidfile?
      !@config.pid_file.nil?
    end

    def daemonize?
      @config.daemonize
    end

    def trap_signals
      trap(:QUIT) do   # graceful shutdown of run! loop
        self.stop
      end
      trap(:INT) do   # graceful shutdown of run! loop
        self.stop
      end
    end

    def connection_string
      "tcp://#{@config.address}:#{@config.port}"
    end

    def log_error(e)
      message = "#{e.message}\n\t" + e.backtrace.join("\n\t")
      @config.error_logger.async.error(message)
    end

    def log(request, start_watch, stop_watch)
      @config.logger.async.info("resource=#{request.resource} method=#{request.method} params=#{request.params} duration=#{(stop_watch - start_watch).round(3)}")
    end

    def send_to_rollbar(e)

    end

    def error_response(e, request)
      id = request.uniq_id rescue 0
      Response.new(1, id, e.message, nil).encode
    end

    def success_response(response, request)
      Response.new(1, request.uniq_id, nil, response).encode
    end

    def get_request(request)

    end

    def send_reponse(response)

    end

    def listen(router)

    end

    def _console_print_
      puts "Karibu starting..."
      puts "- Version #{Karibu::VERSION}, codename: #{Karibu::CODE_NAME}"
      puts "- Min worker: #{@config.workers}"
      puts "- Max worker: #{(@config.workers / 2).round}"
      puts "- Environment: #{Karibu.env}"
      puts "- Resources: #{@config.resources}"
      puts "- Listening on tcp://#{@config.address}:#{@config.port}"
      puts "Use Ctrl-C to stop"
    end
  end
end
