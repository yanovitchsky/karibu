require "spec_helper"

# class App
#   include Karibu::Controller
# end

describe Karibu::Controller do


  # describe "#m_execute" do
  #   it "sets up a hash containing filter and methods" do
  #     App.send(:before_filter, :check_validity, :first, :second)
  #     expect(App.__filters__).to have_key(:check_validity)
  #     expect(App.__filters__[:check_validity]).to eq([:first, :second])
  #   end
  # end
  describe "#invoke" do
    let(:app){
      class App
        include Karibu::Controller
      end
    }
    context "when option is not valid" do
      it 'raises error' do
        expect {
          app.send(:invoke, :test, {:example => :toto})
        }.to raise_error("invalid option(s) example")
      end
    end

    context "when method to invoke does not exist" do
      it 'raise error' do
        expect {
          app.send(:invoke, :test, {before: :plop})
        }.to raise_error(NoMethodError, /test/)
      end
    end

    context "when options method does not exist" do
      let(:myapp){
        class Application
          include Karibu::Controller
        end
      }
      before do
        myapp.send(:define_singleton_method, :test) do
          puts "hello world"
        end

        myapp.send(:define_singleton_method, :toto) do
          puts "hello world"
        end
      end

      it 'raise NoMethodError it before method does not exist' do
        expect{
          myapp.send(:invoke, :test, {before: :plop, after: :toto})
        }.to raise_error(NoMethodError, /plop/)
      end

      it 'raise NoMethodError it after method does not exist' do
        expect{
          myapp.send(:invoke, :test, {before: :toto, after: :echo})
        }.to raise_error(NoMethodError, /echo/)
      end
    end

    context "when invoking with valid params" do
      before do
        @klass = Class.new do
          include Karibu::Controller

          def self.print_name
            puts "Yann Akoun"
          end

          def self.print_age
            puts "30"
          end

          def self.authenticate
            puts "authentication"
          end

          def self.authorize
            puts "authorization"
          end

          def self.clean
            puts "clean"
          end
          def self.add_exit_msg
            puts "exiting method"
          end
        end
      end
      context 'before' do
        before do
          @klass.__filters__ = {}
        end
        context 'single method' do
          it 'invokes before_method then single method' do
            entries = []
            STDOUT.stub(:puts){|arg|
              entries << arg
            }
            @klass.send(:invoke, :authenticate, {before: :print_name})
            @klass.print_name
            expect(entries).to eq(["authentication", "Yann Akoun"])
          end
        end

        context 'multiple methods' do
          it 'invokes before_method before every methods' do
            entries = []
            STDOUT.stub(:puts){|arg|
              entries << arg
            }
            @klass.send(:invoke, [:authenticate, :authorize], {before: [:print_name,:print_age]})
            @klass.print_name
            @klass.print_age
            expect(entries).to eq(["authentication", "authorization", "Yann Akoun", "authentication", "authorization", "30"])
          end
        end
      end
    end

  end
end