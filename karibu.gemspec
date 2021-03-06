# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'karibu/version'

Gem::Specification.new do |spec|
  spec.name          = "karibu"
  spec.version       = Karibu::VERSION
  spec.authors       = ["Yann Akoun"]
  spec.email         = ["yann@visibleo.fr"]

  spec.summary       = %q{Rpc framework in ruby}
  spec.description   = %q{Rpc framework in ruby using zeromq}
  spec.homepage      = "http://visibleo.fr"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.executables   = ['karibu']
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  # spec.add_dependency "convulse-rb"
  spec.add_dependency "concurrent-ruby"
  spec.add_dependency "msgpack"
  spec.add_dependency "ffi-rzmq"
  spec.add_dependency "thor"
  spec.add_dependency 'activesupport'
  spec.add_dependency 'log4r'
end
