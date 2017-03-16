# @author yanovitchsky
module Karibu
  class Logger
    extend Forwardable
    include Concurrent::Async

    def initialize(folder="log")
      puts "Just initialize logger"
    end
  end
end
