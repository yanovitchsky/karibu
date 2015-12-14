module Karibu
  class ClientConfig
    include Singleton
    attr_accessor :symbolize_keys

    def initialize
      @symbolize_keys = true
    end
  end
end
