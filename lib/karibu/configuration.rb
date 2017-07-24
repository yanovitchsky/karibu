# @author yanovitchsky
module Karibu
  class Configuration
    attr_accessor :workers,
                  :port,
                  :address,
                  :timeout,
                  :resources,
                  :logger,
                  :error_logger,
                  :boot_file,
                  :pid_file,
                  :daemonize


    # @return [Numeric] Number of workers to handle the request
    def workers
      @workers || 10
    end

    # @return [Numeric] The port on which the server will listen to
    def port
      @port || 5050
    end

    # @return [String] The ip address the server will listen to
    def address
      @address || "0.0.0.0"
    end

    # @return [Numeric] Time after wich the server will stop the request
    def timeout
      @timeout || 30
    end

    # @return [Array<Class>] List of class exposed via rpc
    def resources
      @resources || []
    end

    # @return [Logger] The logger use to log server requests
    def logger
      @logger || Karibu::Logger.new(Karibu.root.join("log/#{Karibu.env}.log"))
    end

    # @return [Logger] The logger use to log server errors
    def error_logger
      @error_logger || Karibu::Logger.new(Karibu.root.join("log/#{Karibu.env}.error.log"))
    end

    # @return [String] File to load the application
    def boot_file
      @boot_file || Karibu.root.join('boot.rb')
    end

    # @return [String] Full path of pid file
    def pid_file
      @pidfile || Karibu.root.join('karibu.pid')
    end

    # @return [Boolean] Should the server be daemonized
    def daemonize
      @daemonize || false
    end

    # @return [Karibu::Configuration] The server configuration
    def self.configuration
      @configuration ||= Configuration.new
    end

    # @return The configurator object
    def self.configure
      yield configuration
    end

    class << self
      attr_writer :configuration
    end
  end
end
