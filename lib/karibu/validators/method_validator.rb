module Karibu
  class MethodValidator < Validator
    def validate(method, klass)
      if klass.nil?
        [nil, nil]
    end
  end

end
