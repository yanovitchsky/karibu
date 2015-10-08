module Karibu
  class ErrorHandler
    include Karibu::Errors
    attr_accessor :error

    ERRORS=[
      ArgumentError,
      BadRequestError,
      CustomError,
      MethodNotFoundError,
      ServiceResourceNotFoundError,
      TimeoutError,
      UnauthorizedError
    ]

    ERROR_MATCH = {
      ::Timeout::Error => TimeoutError,
      ::ArgumentError  => ArgumentError
    }

    def initialize(e)
      Karibu::LOGGER.async.error(e.message)
      @original = e
      rewrite_error()
    end

    private
    def rewrite_error
      unless ERRORS.include?(@original.class)
        translated_error = ERROR_MATCH[@original.class]
        @error = (translated_error.nil?) ? ServerError : translated_error
      else
        @error = @original
      end
      rescue
        @error = ServerError
    end
  end
end
