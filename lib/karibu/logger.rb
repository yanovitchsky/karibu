module Karibu
  class Logger
    include ::Celluloid
    extend Forwardable

    attr_accessor :logger
    def_delegators :logger, :level, :debug, :info, :warn, :error, :fatal

    def initialize(name='karibu', folder='log')
      p name
      destination = File.directory?(folder) ? "#{folder}/" : ""
      log_file = ENV['KARIBU_ENV'].nil? ? "#{destination}#{name}.log" : "#{destination}#{ENV['KARIBU_ENV']}.log"
      @logger = ::Log4r::Logger.new(name)
      @pattern = ::Log4r::PatternFormatter.new(pattern: "[%l] %d => %m")
      @logger.outputters << ::Log4r::StdoutOutputter.new("#{name}-console", formatter: @pattern)
      @logger.outputters << ::Log4r::FileOutputter.new("#{name}-file", filename: log_file, formatter: @pattern)
    end

    def pattern format
      @logger.outputters.each {|outputter| outputter.formatter = format}
    end

  end
end
