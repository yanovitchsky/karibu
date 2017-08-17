# @author yanovitchsky
module Karibu
  class Dispatcher

    def initialize
      @timeout = Karibu::Configuration.configuration.timeout
      @logger = Karibu::Configuration.configuration.logger
      @resources = Karibu::Configuration.configuration.resources
    end

    # Send the payload to the class exposed and execute it
    def process(payload)
      begin
        check_request(payload)
        response = Timeout::timeout(@timeout) do
          exec_request(payload)
        end
      rescue ResourceNotFoundError, ResourceNotFoundError, ArgumentArityError => e
        # begin
          # print_backtrace(e) if ENV['KARIBU_ENV'] == 'development'
          raise e
      rescue Timeout::Error
        raise ExecutionTimeoutError, "Request took too long to execute"
      end
    end

    private

    def exec_request(payload)
      klass = class_from_string(payload.resource)
      method = payload.method.to_sym
      params = payload.params
      klass.send(method, *params)
    end

    def check_request(payload)
      check_resource payload
      check_method payload
      check_arity payload
    end

    def check_resource(payload)
      begin
        klass = class_from_string(payload.resource)
        unless @resources.include? klass
          raise ResourceNotFoundError, "Cannot find resource #{payload.resource}"
        end
      rescue NameError
        raise ResourceNotFoundError, "Cannot find resource #{payload.resource}"
      end
    end

    def check_method(payload)
      klass = class_from_string(payload.resource)
      unless klass.respond_to? payload.method.to_sym
        raise MethodNotFoundError, "Cannot find method #{payload.method} in resource #{payload.resource}"
      end
    end

    def check_arity(payload)
      klass = class_from_string(payload.resource)
      method = payload.method.to_sym

      if klass.method(method).arity != payload.params.size
        raise ArgumentArityError, "Wrong number of arguments #{payload.params.size} for method #{payload.method}"
      end
    end

    def _log_error

    end

    def _log

    end

    def report_to_rollbar(error, payload)
      if defined?(Rollbar)
        Rollbar.error(error, payload)
      end
    end

    def class_from_string(str)
      str.split('::').inject(Object) do |mod, class_name|
        mod.const_get(class_name)
      end
    end
  end
end
