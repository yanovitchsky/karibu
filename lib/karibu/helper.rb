module Karibu
  module Helper
    def self.included(base)
      base.include(Karibu::Errors)
    end
  end
end