m# @author yanovitchsky
module Karibu
  class Logger
    extend Forwardable
    include Concurrent::Async

    attr_accessor :logger
    def_delegators :logger, :level, :debug, :info, :warn, :error, :fatal

    def initialize(folder="log")
      destination = File.directory?(folder) ? "#{folder}/" : ""
      log = "#{destination}#{ENV['KARIBU_ENV']}.log"
      error_log = "#{destination}#{ENV['KARIBU_ENV']}.error.log"
      @logger = ::Log4r::Logger.new
      @error_logger = ::Log4r::Logger.new
      @pattern = ::Log4r::PatternFormatter.new(pattern: "[%l] %d => %m")
      @logger.outputters << ::Log4r::StdoutOutputter.new("#{name}-console", formatter: @pattern)
      @logger.outputters << ::Log4r::FileOutputter.new("#{name}-file", filename: log_file, formatter: @pattern)
    end
  end
end
