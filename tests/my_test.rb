require 'ffi-rzmq'
require File.expand_path('../../lib/karibu', __FILE__)


addr1 = "tcp://127.0.0.1:8900"
addr2 = "tcp://127.0.0.1:8901"

class UserModuleTest
  # include Karibu::Helpers

  # params_for :echo do
  #  optional :test, type: Integer
  # end
  def self.echo(number)
    # n = rand(3..6)
    # sleep(1)
    "I have received #{number}"
  end

  def self.sort(array)
    array.sort{|a,b| a <=> b}
  end

  def self.test
    return "hello World"
  end

  # params_for :toto do

  # end
  # def self.toto
  #
  # end
end

# Karibu::Doc.new do
#   desc 'permits name for someone'
#   arg 'x', type: String, desc: "name of string"
# end
class Middleware
  def initialize(app)
    @app = app
  end

  def call(request)
    puts "je suis dans mon middleware"
    response = @app.call(request)
    {sucess: response}
  end
end

# p "setting log file ------------------------"
# Karibu::LOGFILE = "test.log"

class TestService < Karibu::Service
  connection_string "tcp://127.0.0.1:5000"
  threads 10
  expose 'UserModuleTest#sort'
  # expose 'Documentation#call'
  # expose 'Message#echo' do
  #   desc 'permits name for someone'
  #   arg 'x', type: String, desc: "name of string"
  #   arg 'c', type: Integer, desc: "number of stripes"
  #   returns "string containing hello word", String
  # end
  # use Middleware
  # response_timeout 40
end

# class TestServiceTwo < Karibu::Service
#   connection_string "tcp://127.0.0.1:8901"
#   threads 30
#   expose 'Message#echo'
#   # expose 'Documentation#call'
#   # expose 'Message#echo' do
#   #   desc 'permits name for someone'
#   #   arg 'x', type: String, desc: "name of string"
#   #   arg 'c', type: Integer, desc: "number of stripes"
#   #   returns "string containing hello word", String
#   # end
#   # use Middleware
#   # response_timeout 40
# end
# class TestServiceThree < Karibu::Service
#   connection_string "tcp://127.0.0.1:8902"
#   threads 30
#   expose 'Message#echo'
#   # expose 'Documentation#call'
#   # expose 'Message#echo' do
#   #   desc 'permits name for someone'
#   #   arg 'x', type: String, desc: "name of string"
#   #   arg 'c', type: Integer, desc: "number of stripes"
#   #   returns "string containing hello word", String
#   # end
#   # use Middleware
#   # response_timeout 40
# end
#
# class TestServiceFour < Karibu::Service
#   connection_string "tcp://127.0.0.1:7000"
#   threads 30
#   expose 'Message#test'
#   # expose 'Documentation#call'
#   # expose 'Message#echo' do
#   #   desc 'permits name for someone'
#   #   arg 'x', type: String, desc: "name of string"
#   #   arg 'c', type: Integer, desc: "number of stripes"
#   #   returns "string containing hello word", String
#   # end
#   # use Middleware
#   # response_timeout 40
# end



# p Documentation.call
#Message.echo(x:String) # "permits name for someone", x:String(name of string)
# class Client
#   include Celluloid::ZMQ

#   def initialize(address)
#     @socket = ReqSocket.new

#     begin
#       @socket.connect(address)
#     rescue IOError
#       @socket.close
#       raise
#     end
#   end

#   def write(message)
#     @socket.send(message)
#     nil
#   end

#   def recv
#     # # id = @socket.recv()
#     # # msg = @socket.read
#     # p "waiting on recv"
#     # loop { p @socket.read }
#     # # p id
#     # # p msg
#     p 'reading'
#     test = ''
#     @socket.read test
#     p "got response: #{test}"

#   end
# end

# env = ENV['KARIBU_ENV']
# p env
# Karibu::LOGGER = Karibu::Logger.new(env, 'log')

TestService.start()
# TestServiceTwo.start()
# TestServiceThree.start()
# TestServiceFour.start()

sleep
