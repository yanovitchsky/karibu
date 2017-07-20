# @author yanovitchsky
module Karibu
  class Logger
    extend Forwardable
    # include Concurrent::Async

    attr_accessor :logger, :error_logger
    def_delegators :logger, :level, :debug, :info, :warn, :error, :fatal

    def initialize(log_file)
      create_directory_if_does_not_exist(log_file)
      @logger = ::Log4r::Logger.new log_file.to_s
      @pattern = ::Log4r::PatternFormatter.new(pattern: "[%l] %d => %m")

      # Define logger location
      @logger.outputters << ::Log4r::StdoutOutputter.new("log-console", formatter: @pattern)
      @logger.outputters << ::Log4r::FileOutputter.new("log-file", filename: log_file.to_s, formatter: @pattern)
    end

    private
    def create_directory_if_does_not_exist(log_file)
      log_dir = File.dirname(log_file)
      unless File.directory?(log_dir)
        FileUtils.mkdir_p(log_dir)
      end
    end
  end
end
