require "spec_helper"

class TestClient < Karibu::Client
  connection_string "toto"
end
describe Karibu::Client do
  before do
    ::ZMQ::Context.stub(:connect)
  end
  describe "#async" do
    it 'respond to async' do
      expect(TestClient::Message).to respond_to(:async)
    end

    it 'respond to future' do
      expect(TestClient::Message).to respond_to(:future)
    end
  end
end