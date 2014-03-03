module Karibu
  module Errors
    class BadMessageFormat < StandardError
    end

    class ServiceResourceNotFound < StandardError
    end

    class MethodNotFound < StandardError
    end
  end
end