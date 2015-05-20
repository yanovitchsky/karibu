require "spec_helper"

describe Karibu::Service do
  describe ".connection_string" do
    before do
      class Test < Karibu::Service
        connection_string "tcp://127.0.0.1:3000"
      end
    end
    it "adds the connection string to Service.addr" do
      expect(Test.addr).to eq("tcp://127.0.0.1:3000")
    end
  end

  describe ".expose" do
    before do
      class Call
        def self.stats;end
        def self.count;end
      end
      class Test < Karibu::Service
        expose "Call#stats"
        expose "Call#count"
      end
    end
    context "when called" do
      it 'adds the route to Service.exposed_methods' do
        # p Test.routes
        expect(Test.routes.size).to eq(1)
        expect(Test.routes).to have_key(Call)
        expect(Test.routes[Call].size).to eq(2)  
      end
    end
    context "when the route class does not exist" do
      it {expect { Test.send(:expose, 'Message#all') }.to raise_error(Karibu::Errors::MethodNotFoundError) }
      it "raises MethodNotFoundError" do
        class Message;end
        expect { Test.send(:expose, 'Call#all') }.to raise_error(Karibu::Errors::MethodNotFoundError)
      end
    end
  end

  describe ".start" do
    
  end
end