module Karibu
  #[type, msgid, resource, method, params]
  class Request
    attr_accessor :identity, :uniq_id, :resource, :method_called, :params 
    def initialize(identity, packet)
      @identity = identity
      @msg = MessagePack.unpack(packet)
      decode()
    end

    private

    def decode
      [:type=, :uniq_id=, :resource=, :method_called=, :params=].each_with_index do |meth, index|
        self.send(meth, @msg[index])
      end
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
      raise BadMessageFormat unless (@msg[0].is_a? Integer && @msg[0] != 0)
    end

    def check_id
      raise BadMessageFormat unless @msg[1].is_a? Integer
    end

    def check_resource
      raise BadMessageFormat unless @msg[2].is_a? String
    end

    def check_method
      raise BadMessageFormat unless @msg[3].is_a? String
    end

    def check_params
      raise BadMessageFormat unless @msg[4].is_a? Array
    end
  end
end