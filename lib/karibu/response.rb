module Karibu
  class Response
    attr_accessor :identity
    def initialize(identity, type, id, error, result)
      @identity = identity
      @type = type
      @id = id
      @error = error
      @result = result
      check_msg()
    end

    def encode
      MessagePack.pack([@type, @id, @error, @result])
    end

    private
    def check_msg
      
    end
  end
end