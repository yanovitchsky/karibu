module Karibu
  class KlassValidator < Validator
    def validate(klass)
      klasses = Karibu::Configuration.configuration.klasses
      if klasses.include? klass
        klass
      else
        nil
      end
    end
  end

end
