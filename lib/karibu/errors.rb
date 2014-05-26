module Karibu
  module Errors
    class Error < StandardError
      def initialize(msg)
        super(msg)
      end
    end

    class ArgumentError < Error;end

    class BadRequestError < Error;end

    class CustomError < Error;end
    
    class ClientError < Error;end

    class MethodNotFoundError < Error;end

    class ServerError < Error
      def initialize(msg='server has encontered an error please try again later')
        super(msg)        
      end
    end

    class ServiceResourceNotFoundError < Error;end

    class TimeoutError < Error
      def initialize(msg='execution expired')
        super(msg)
      end
    end

    class UnauthorizedError < Error;end
  end
end