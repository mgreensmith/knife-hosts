# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "knife-hosts/version"

Gem::Specification.new do |gem|
  gem.name          = "knife-hosts"
  gem.version       = KnifeHosts::VERSION
  gem.authors       = ["Matt Greensmith"]
  gem.email         = ["matt@mattgreensmith.net"]
  gem.description   = %q{Knife plugin to print node names and IPs formatted for inclusion in a hosts file.}
  gem.summary       = %q{Knife plugin to format nodes for a hosts file.}
  gem.homepage      = "http://github.com/mgreensmith/knife-hosts"

  gem.add_development_dependency "bundler", ">= 1.0.0"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
