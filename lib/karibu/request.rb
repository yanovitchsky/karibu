module Karibu
  #[type, msgid, resource, method, params]
  class ServerRequest
    attr_accessor :uniq_id, :resource, :method_called, :params 
    def initialize(packet)
      @packet = packet
      # check_msg()
    end

    def decode
      msg = MessagePack.unpack(@packet)
      [:type=, :uniq_id=, :resource=, :method_called=, :params=].each_with_index do |meth, index|
        self.send(meth, msg[index])
      end
      self
    end

    def encode
      @msg = MessagePack.pack(@packet)
    end

    def type=(type);end

    def check_msg
      raise BadMessageFormat if @msg.size != 5
      check_type
      check_id
      check_resource
      check_method
      check_params
    end

    def check_type
      raise Karibu::Errors::BadMessageFormat unless (@msg[0].is_a?(Fixnum) && @msg[0] == 0)
    end

    def check_id
      raise Karibu::Errors::BadMessageFormat unless @msg[1].is_a? String
    end

    def check_resource
      raise Karibu::Errors::BadMessageFormat unless @msg[2].is_a? String
    end

    def check_method
      raise Karibu::Errors::BadMessageFormat unless @msg[3].is_a? ::String
    end

    def check_params
      raise Karibu::Errors::BadMessageFormat unless @msg[4].is_a? ::Array
    end
  end

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