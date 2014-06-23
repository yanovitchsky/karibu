module Karibu
  class ServerResponse
    attr_accessor :type, :id, :error, :result
    def initialize(type, id, error, result)
      @type = type
      @id = id
      @error = error
      @result = result
      check_msg()
    end

    def encode
      res = MessagePack.pack([@type, @id, @error, @result])
    end

    # def decode
    #   [:type, :id, :error, :result].each_with_index do |m, i|
    #     self.send(m, )
    #   end
    #   self
    # end


    def to_s
     "[:id => #{id}, :error => #{error}, :result => #{result}]"
    end

    private
    def check_msg
      
    end
  end

  class ClientResponse
    attr_accessor :type, :id, :error, :result
    def initialize(packet)
      @packet = packet
    end

    def decode
      msg = MessagePack.unpack(@packet, :symbolize_keys => true, :encoding => Encoding::UTF_8)
      [:type=, :id=, :error=, :result=].each_with_index do |meth, index|
        self.send(meth, msg[index])
      end
      self
    end
  end
end