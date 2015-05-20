require 'fileutils'
module Karibu
  class CLI
    attr_accessor :options

    def initialize(options={})
      @options = final_options(options)
      raise "port #{@options[:port]} is already used" if port_open?(@options[:port])
      ENV['KARIBU_ENV'] = @options[:environment] || "development"
      @service = create_service @options
      if @service.nil?
        raise "Unable to load server no service has been defined"
        # load_middleware
        # expose_endpoints
      end
    end

    def start
      begin
        unless @options[:daemon]
          @service.start
          sleep()
        else
          pid = fork do
            $stdout.reopen("/dev/null", "w")
            @service.start
            sleep()
          end
          dirname = File.dirname(@options[:pidfile])
          unless dirname == "."
            FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
            pidfile = @options[:pidfile].split('/').last 
          else
            pidfile = @options[:pidfile]
          end
          Dir.chdir(dirname) do
            File.open(pidfile, "w+") { |io| io.write(pid) } if @options[:pidfile]
          end
        end
      rescue Exception => e
        puts "Unable to start karibu server"
        p e.message
      end
    end

    private

    def final_options(options)
      {
        bind: "127.0.0.1",
        port:    8900,
        thread: 10,
        daemon:  false,
        environment: "development",
        initfile: "run.rb",
        pidfile: "pids/karibu.pid"
      }.merge(options)
    end

    def create_service(options)
      load options[:initfile]
      service = ::Karibu::Service.__children__.first rescue nil
      unless service.nil?
        service.class_eval do
          connection_string "tcp://#{options[:bind]}:#{options[:port]}"
          threads options[:thread].to_i
        end
      end
      service
    end

    def load_middleware
      @options[:middlewares].reverse.each do |mdw|
        klass = mdw[:klass]
        args  = mdw[:args]
        args << mdw[:block] if mdw[:block]
        @service.class_eval do
          use klass if args.empty?
          use klass, args unless args.empty?
        end
      end
    end

    def expose_endpoints
      @options[:endpoints].each do |endpoint|
        @service.class_eval do
          expose endpoint
        end
      end
    end

    def port_open?(port)
      system("lsof -i:#{port}", out: '/dev/null')
    end
  end
end