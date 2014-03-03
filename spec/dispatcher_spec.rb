require "spec_helper"

class Call
  def self.stats
  end
end

describe Karibu::Dispatcher do
  let(:dispatcher) { 
    Karibu::Dispatcher.new(
      ::ZMQ::Context.new(1),
      "tcp://127.0.0.1:3000",
      {Call => :stats}
    ) 
  } 
  describe ".process_request" do
    context "When execution does not raise error" do
      it 'creates a server response with error nil' do
        response = dispatcher.process_request(
          MessagePack.pack([0, '1', 'Call', 'stats', []])
        )
        expect(response.error).to be_nil
      end 
    end

    context "When execution raises error" do
      it 'creates a server response with ServiceResourceNotFound' do
        response = dispatcher.process_request(
          MessagePack.pack([0, '1', 'Plop', 'stats', []])
        )
        expect(response.error).to eq("Karibu::Errors::ServiceResourceNotFound")
      end

      it 'creates a server response with MethodNotFound' do
        response = dispatcher.process_request(
          MessagePack.pack([0, '1', 'Call', 'echo', []])
        )
        expect(response.error).to eq("Karibu::Errors::MethodNotFound")
      end 
    end
    
  end
end