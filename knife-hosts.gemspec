# -*- encoding: utf-8 -*-
chef_version = ENV.key?('CHEF_VERSION') ? "= #{ENV['CHEF_VERSION']}" : ['~> 10.12']
require File.expand_path('../lib/knife-hosts', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "knife-hosts"
  gem.version       = KnifeHosts::VERSION
  gem.authors       = ["Matt Greensmith"]
  gem.email         = ["matt@mattgreensmith.net"]
  gem.description   = %q{Knife plugin to print node names and IPs formatted for inclusion in a hosts file.}
  gem.summary       = %q{Knife plugin to format nodes for a hosts file.}
  gem.homepage      = "github.com/mgreensmith/knife-hosts"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
