module Karibu
  class Logger
    include ::Celluloid
    extend Forwardable

    attr_accessor :logger
    def_delegators :logger, :level, :debug, :info, :warn, :error, :fatal

    def initialize(name='karibu-logger')
      @logger = ::Log4r::Logger.new(name)
      format = ::Log4r::PatternFormatter.new(pattern: "[%l] %d => %m")
      @logger.outputters << ::Log4r::StdoutOutputter.new("#{name}-console", formatter: format)
      @logger.outputters << ::Log4r::FileOutputter.new("#{name}-file", filename: (Karibu::LOGFILE || "#{name}.log"), formatter: format)
    end
  end
end