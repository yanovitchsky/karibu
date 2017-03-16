require 'spec_helper'
require "logger"

describe Karibu::Configuration do
    describe "#configure.default" do
      let(:config){Karibu::Configuration.configuration}
      it 'returns default number of workers' do
        expect(config.workers).to eq(10)
      end

      it "returns default port number" do
        expect(config.port).to eq(5050)
      end

      it "returns default timeout" do
        expect(config.timeout).to eq(30)
      end

      it "returns empty list of klasses" do
        expect(config.klasses.size).to eq(0)
      end

      it "returns a default logger" do
        expect(config.logger).to be_instance_of(Karibu::Logger)
      end
    end

    describe "#configure" do
      let(:conf){
        Karibu::Configuration.configure do |config|
          config.workers = 20
          config.timeout = 60
          config.port = 8000
          config.klasses = [Karibu::Request]
          config.logger = Logger.new(STDOUT)
        end
        Karibu::Configuration.configuration
      }

      it 'returns number of workers' do
        expect(conf.workers).to eq(20)
      end

      it "returns port number" do
        expect(conf.port).to eq(8000)
      end

      it "returns timeout" do
        expect(conf.timeout).to eq(60)
      end

      it "returns the list of klasses" do
        expect(conf.klasses.size).to eq(1)
      end

      it "returns logger" do
        expect(conf.logger).to be_instance_of(Logger)
      end
    end
end
