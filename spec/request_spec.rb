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
    context "when packet is malformed" do

      it 'raises BadMessageFormat on type' do
        packet = MessagePack.pack([1, 1, 'Call', 'stats', []])
        expect { Karibu::Request.new(packet)}.to raise_error(Karibu::Errors::BadMessageFormat)
      end

      it 'raises BadMessageFormat on id' do
        packet = MessagePack.pack([0, '1', 'Call', 'stats', []])
        expect { Karibu::Request.new(packet)}.to raise_error(Karibu::Errors::BadMessageFormat)
      end

      it 'raises BadMessageFormat on resource' do
        packet = MessagePack.pack([0, 1, 12, 'stats', []])
        expect { Karibu::Request.new(packet)}.to raise_error(Karibu::Errors::BadMessageFormat)
      end

      it 'raises BadMessageFormat on method_called' do
        packet = MessagePack.pack([0, 1, 'Call', 2, []])
        expect { Karibu::Request.new(packet)}.to raise_error(Karibu::Errors::BadMessageFormat)
      end

      it 'raises BadMessageFormat on params' do
        packet = MessagePack.pack([0, 1, 'Call', 'stats', 12])
        expect { Karibu::Request.new(packet)}.to raise_error(Karibu::Errors::BadMessageFormat)
      end 
    end
  end
end