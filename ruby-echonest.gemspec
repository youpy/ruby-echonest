# -*- encoding: utf-8 -*-
require File.expand_path('../lib/echonest/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["youpy"]
  gem.email         = ["youpy@buycheapviagraonlinenow.com"]
  gem.description   = %q{An Ruby interface for Echo Nest Developer API}
  gem.summary       = %q{An Ruby interface for Echo Nest Developer API}
  gem.homepage      = "http://github.com/youpy/ruby-echonest"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "ruby-echonest"
  gem.require_paths = ["lib"]
  gem.version       = Echonest::VERSION

  gem.add_dependency('httpclient')
  gem.add_dependency('hashie')
  gem.add_dependency('libxml-ruby')

  gem.add_development_dependency('rspec', ['~> 2.8.0'])
  gem.add_development_dependency('rake')
  gem.add_development_dependency('ruby-echonest')
end
