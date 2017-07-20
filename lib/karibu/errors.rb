# @author yanovitchsky
class KaribuError < StandardError
  def initialize(msg=nil)
    super(msg)
  end
end

class ResourceNotFoundError < KaribuError;end
class MethodNotFoundError < KaribuError;end
class ArgumentArityError < KaribuError;end
class ExecutionTimeoutError < KaribuError;end
class BadRequestError < KaribuError;end
