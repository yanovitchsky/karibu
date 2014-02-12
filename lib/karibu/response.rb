module Karibu
  class Response
    def initialize(type, id, error, result)
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