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
      # worker_url = "inproc://karibu-#{SecureRandom.hex(6)}-workers"
      @config = Karibu::Configuration.configuration
      p @config.pidfile
      @worker_pool = Concurrent::ThreadPoolExecutor.new(
        min_threads: @config.workers,
        max_thread: @config.workers + (@config.workers / 2).round,
        max_queue: 100
      )
      @ctx = ::ZMQ::Context.new
      @request_mapper = Concurrent::Map.new
      @running = true
    end

    def run!
      check_pid
      daemonize if daemonize?
      write_pid
      trap_signals

      while @running
        p "Hello World"
        sleep(2)
      end
    end

    def stop
      @running = false
      cleanup
      kill_pid
    end

    def cleanup
      p "cleaning up"
    end

    private

    def check_pid
      pidfile = @config.pidfile
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
      pidfile = @config.pidfile
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
        pid = ::File.read(@config.pidfile).to_i
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
      !@config.pidfile.nil?
    end

    def daemonize?
      @config.daemonize
    end

    def trap_signals
      trap(:QUIT) do   # graceful shutdown of run! loop
        @running = false
      end
    end

    def exec request
      Concurrent::Future.execute(executor: @worker_pool) do
        Dispatcher.new(request).process
      end
    end
  end
end
