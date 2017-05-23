# -*- encoding: utf-8 -*-
# stub: classify 0.0.3 ruby lib

Gem::Specification.new do |s|
  s.name = "classify".freeze
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Linus Oleander".freeze]
  s.date = "2011-02-18"
  s.description = "Converts strings into constants using Ruby. Something simular to Rails' classify method.".freeze
  s.email = ["linus@oleander.nu".freeze]
  s.homepage = "https://github.com/oleander/classify".freeze
  s.rubyforge_project = "classify".freeze
  s.rubygems_version = "2.6.6".freeze
  s.summary = "Converts strings into constants using Ruby".freeze

  s.installed_by_version = "2.6.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
  end
end
