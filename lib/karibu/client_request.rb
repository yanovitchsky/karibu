module Karibu
  class ClientRequest
    attr_accessor :id, :resource, :method_called, :params 

    def initialize(resource, method_called, params)
      @resource = resource
      @method_called = method_called
      @params = params
      @id = SecureRandom.hex(10)
    end

    def encode
      MessagePack.pack([0, @id, @resource, @method_called, @params])
    end
  end
end