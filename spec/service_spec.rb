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
      end
      class Test < Karibu::Service
        expose "call#stats"
      end
    end
    context "when called" do
      it 'adds the route to Service.exposed_methods' do
        expect(Test.routes.size).to eq(1)
        expect(Test.routes).to have_key(Call)  
        expect(Test.routes[Call]).to eq(:stats)  
      end
    end
    context "when the route class does not exist" do
      it {expect { Test.send(:expose, 'message#all') }.to raise_error(Karibu::Errors::ServiceResourceNotFound) }
      it "raises MethodNotFound" do
        class Message;end
        expect { Test.send(:expose, 'call#all') }.to raise_error(Karibu::Errors::MethodNotFound)
      end
    end
  end

  describe ".start" do
    
  end
end