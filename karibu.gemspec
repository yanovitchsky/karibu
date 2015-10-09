# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'karibu/version'

Gem::Specification.new do |spec|
  spec.name          = "karibu"
  spec.version       = Karibu::VERSION
  spec.authors       = ["Yann Akoun"]
  spec.email         = ["yannakoun@gmail.com"]
  spec.summary       = "Karibu RPC service"
  spec.description   = "Karibu is intented to be a async service framework for doing rpc call like thrift over zeromq"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency 'simplecov'


  spec.add_dependency "celluloid-io"
  spec.add_dependency "celluloid-zmq"
  spec.add_dependency "log4r"
  spec.add_dependency "hamster"
  spec.add_dependency "connection_pool"
  spec.add_dependency "thor"
  spec.add_dependency "concurrent-ruby"
  # spec.add_dependency "activesupport"
  # spec.add_dependency 'activesupport-inflector'
  spec.add_dependency 'i18n'
  # spec.add_dependency "msgpack-jruby"
  # spec.add_dependency "msgpack" if RUBY_PLATFORM != 'java'
  # spec.add_dependency "msgpack-jruby" if RUBY_PLATFORM == 'java'
  # spec.add_dependency "concurrent-ruby"
end
