require "spec_helper"

describe Karibu::Server do
  describe '._exec!' do
    context 'when sending bad packet' do
      it "raise BadRequestError" do
        request = MessagePack.pack("hello world")
        expect{Karibu::Server.instance.send(:_exec!, request)}.to raise_error(BadRequestError)
      end
    end

    context 'When application return an error' do
      it 'instructs to log to error' do
        # expect(Karibu::Configuration.configuration.error_logger).to receive(:error)
        request = MessagePack.pack("hello world")
        p Karibu::Server.instance.send(:_exec!, request)
      end

      it 'returns error packet' do

      end

      context 'When KARIBU_ENV is development' do
        it 'instructs to log to STDOUT' do

        end
      end
    end

    context 'When application respond success' do
      it 'instructs to log to application' do

      end

      it 'returns success packet' do

      end

      context 'When KARIBU_ENV is development' do
        it 'instructs to log to STDOUT' do

        end
      end
    end
  end
end
