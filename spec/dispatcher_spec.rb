require 'spec_helper'

class DummyError < StandardError; end
class Dummy
  def self.multiply(input)
    input * 2
  end

  def self.slow
    sleep(2)
  end

  def self.message_raise
    raise "Oups"
  end

  def self.error_raise
    raise DummyError
  end

  def self.error_and_message_raise
    raise DummyError, "Oh lala"
  end
end

describe Karibu::Dispatcher do
  describe '.process' do
    before do
      Karibu::Configuration.configure do |config|
        config.workers = 20
        config.timeout = 1
        config.port = 8000
        config.resources = [Dummy]
        config.logger = Logger.new(STDOUT)
      end
  end
    let(:dispatcher){
      Karibu::Dispatcher.new
    }
    context "when class is not exposed" do
      it 'raises ResourceNotFoundError' do
        request = Karibu::Request.new(MessagePack.pack([0, '1', 'Plop', 'stats', []])).decode
        expect { dispatcher.process(request)}.to raise_error(ResourceNotFoundError, "Cannot find resource Plop")
      end
    end

    context "when method in class does not exit" do
      it "raises MethodNotFoundError" do
        request = Karibu::Request.new(MessagePack.pack([0, '1', 'Dummy', 'stats', []])).decode
        expect { dispatcher.process(request)}.to raise_error(MethodNotFoundError, "Cannot find method stats in resource Dummy")
      end
    end

    context 'when argument arity is wrong' do
      it "raises ArgumentArityError" do
        request = Karibu::Request.new(MessagePack.pack([0, '1', 'Dummy', 'multiply', []])).decode
        expect { dispatcher.process(request)}.to raise_error(ArgumentArityError, "Wrong number of arguments 0 for method multiply")
      end
    end

    context 'when time is up' do
      it "raise ExecutionTimeoutError" do
        request = Karibu::Request.new(MessagePack.pack([0, '1', 'Dummy', 'slow', []])).decode
        expect { dispatcher.process(request)}.to raise_error(ExecutionTimeoutError, "Request took too long to execute")
      end
    end

    context 'When application raise error' do
      it "reraise application message error" do
        request = Karibu::Request.new(MessagePack.pack([0, '1', 'Dummy', 'message_raise', []])).decode
        expect { dispatcher.process(request)}.to raise_error("Oups")
      end

      it "reraise application class error" do
        request = Karibu::Request.new(MessagePack.pack([0, '1', 'Dummy', 'error_raise', []])).decode
        expect { dispatcher.process(request)}.to raise_error(DummyError)
      end

      it "reraise application class and message error" do
        request = Karibu::Request.new(MessagePack.pack([0, '1', 'Dummy', 'error_and_message_raise', []])).decode
        expect { dispatcher.process(request)}.to raise_error(DummyError, "Oh lala")
      end
    end

    context 'when no error' do
      it 'executes' do
        request = Karibu::Request.new(MessagePack.pack([0, '1', 'Dummy', 'multiply', [2]])).decode
        expect(dispatcher.process(request)).to eq(4)
      end
    end
  end
end
