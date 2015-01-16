module Karibu
  module Errors
    class Error < StandardError
      def initialize(msg=nil)
        super(msg)
      end
    end

    class ArgumentError < Error;end #client 9901

    class BadRequestError < Error;end #client 9904

    class CustomError < Error;end #server 9701
    
    class ClientError < Error;end #client

    class MethodNotFoundError < Error;end #client 9905

    class ServerError < Error #server
      def initialize(msg='server has encontered an error please try again later')
        super(msg)        
      end
    end

    class ServiceResourceNotFoundError < Error;end #client 9905

    class TimeoutError < Error #server 9709
      def initialize(msg='execution expired')
        super(msg)
      end
    end

    class UnauthorizedError < Error;end #client badauth => 9902, badright => 9903
  end
end