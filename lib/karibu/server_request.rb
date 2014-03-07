module Karibu
  class ServerRequest
    attr_accessor :uniq_id, :resource, :method_called, :params 
    def initialize(packet)
      @packet = packet
    end

    def decode
      @msg = MessagePack.unpack(@packet)
      check_msg()
      [:type=, :uniq_id=, :resource=, :method_called=, :params=].each_with_index do |meth, index|
        self.send(meth, @msg[index])
      end
      self
    end

    # def encode
    #   @msg = MessagePack.pack(@packet)
    # end

    def type=(type);end

    def to_s
      "[:id => #{uniq_id}, :resource => #{resource}, :method => #{method_called}, :params => #{params.join(',')}]"
    end

    private

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
  
end