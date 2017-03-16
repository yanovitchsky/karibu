# @author yanovitchsky
module Karibu
  class Dispatcher

    def initialize
      @timeout = Karibu::Configuration.configuration.timeout
      @logger = Karibu::Configuration.configuration.logger
    end

    def process(request)
      begin
        start_trace = Time.now
        decoded_request = Karibu::Request.new(msg).decode
        response = Timeout::timeout(@timeout) do
          exec_request(decoded_request)
        end
        _log(request, start_trace)
        response
      rescue => e
        begin
          print_backtrace(e) if ENV['KARIBU_ENV'] == 'development'
        rescue => e

        end
      end
    end

    private

    def check_request(request)
      PromiseLike.new{request}.
        .then{|request| check_resource}
        .then{|request| check_method}
        .then{|request| check_params}
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
  end
end
