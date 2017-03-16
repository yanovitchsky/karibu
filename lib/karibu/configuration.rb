# @author yanovitchsky
module Karibu
  class Configuration
    attr_accessor :workers,
                  :port,
                  :address,
                  :timeout,
                  :klasses,
                  :logger,
                  :pidfile,
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
      @address || "127.0.0.1"
    end

    # @return [Numeric] Time after wich the server will stop the request
    def timeout
      @timeout || 30
    end

    # @return [Array<Class>] List of class exposed via rpc
    def klasses
      @klasses || []
    end

    # @return [Logger] The logger use to log server requests
    def logger
      @logger || Karibu::Logger.new
    end

    # @return [String] Full path of pid file
    def pidfile
      @pidfile || File.expand_path('../../../karibu.pid', __FILE__)
    end

    # @return [Boolean] Should the server be daemonized
    def daemonize
      @daemonize || true
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
