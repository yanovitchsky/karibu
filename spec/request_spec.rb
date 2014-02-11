require "spec_helper"

describe Karibu::Request do
  describe "#initialize" do
    before do
      @packet = MessagePack.pack([0, 1, 'Call', "stats", [23]])
    end 
    context "when creating a new instance" do
      let(:request) { Karibu::Request.new(@packet) }

      it 'has an id' do
        expect(request.uniq_id).to eq(1)
      end
      it "has a resource" do
        expect(request.resource).to eq('Call')
      end
      it "has a method" do
        expect(request.method_called).to eq('stats')
      end
      it "has parameters" do
        expect(request.params).to eq([23])
      end
    end
  end
end