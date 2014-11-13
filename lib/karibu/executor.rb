module Karibu
  class Executor
    def call(request)
      klass = Kernel.const_get(request.resource)
      meth = request.method_called.to_sym
      klass.send(meth, *request.params)
    end
  end
end