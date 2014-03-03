require "spec_helper"

describe Karibu::ServerRequest do
  describe ".decode" do
    context "when packet is well formed" do
      let(:request) { Karibu::ServerRequest.new(MessagePack.pack([0, '1', 'Call', "stats", [23]])).decode() }

      it "gets an id" do
        expect(request.uniq_id).to eq('1')
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

    context "When packet is malformed" do
      it 'raises BadMessageFormat on type' do
        packet = MessagePack.pack([1, '1', 'Call', 'stats', []])
        expect { Karibu::ServerRequest.new(packet).decode()}.to raise_error(Karibu::Errors::BadMessageFormat)
      end

      it 'raises BadMessageFormat on id' do
        packet = MessagePack.pack([0, [3], 'Call', 'stats', []])
        expect { Karibu::ServerRequest.new(packet).decode()}.to raise_error(Karibu::Errors::BadMessageFormat)
      end

      it 'raises BadMessageFormat on resource' do
        packet = MessagePack.pack([0, '1', 12, 'stats', []])
        expect { Karibu::ServerRequest.new(packet).decode()}.to raise_error(Karibu::Errors::BadMessageFormat)
      end

      it 'raises BadMessageFormat on method_called' do
        packet = MessagePack.pack([0, '1', 'Call', 2, []])
        expect { Karibu::ServerRequest.new(packet).decode()}.to raise_error(Karibu::Errors::BadMessageFormat)
      end

      it 'raises BadMessageFormat on params' do
        packet = MessagePack.pack([0, '1', 'Call', 'stats', 12])
        expect { Karibu::ServerRequest.new(packet).decode()}.to raise_error(Karibu::Errors::BadMessageFormat)
      end 
    end
  end
end