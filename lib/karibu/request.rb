# @author yanovitchsky
module Karibu
  class Request
    attr_accessor :uniq_id, :resource, :method_called, :params
    def initialize(packet)
      @packet = packet
    end

    def decode
      @msg = MessagePack.unpack(@packet, :symbolize_keys => true, :encoding => Encoding::UTF_8)
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
      raise BadRequestError if @msg.size != 5
      check_type
      check_id
      check_resource
      check_method
      check_params
    end

    def check_type
      raise Karibu::Errors::BadRequestError unless (@msg[0].is_a?(Fixnum) && @msg[0] == 0)
    end

    def check_id
      raise Karibu::Errors::BadRequestError unless @msg[1].is_a? String
    end

    def check_resource
      raise Karibu::Errors::BadRequestError unless @msg[2].is_a? String
    end

    def check_method
      raise Karibu::Errors::BadRequestError unless @msg[3].is_a? ::String
    end

    def check_params
      raise Karibu::Errors::BadRequestError unless @msg[4].is_a? ::Array
    end
  end

end
