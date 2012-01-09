require 'bundler'
Bundler.require

$LOAD_PATH.unshift "lib"
require 'echonest'

Jeweler::Tasks.new do |gem|
  gem.name = "ruby-echonest"
  gem.version = Echonest::VERSION
  gem.summary = "An Ruby interface for Echo Nest Developer API"
  gem.description = "An Ruby interface for Echo Nest Developer API"
  gem.email = "youpy@buycheapviagraonlinenow.com"
  gem.homepage = "http://github.com/youpy/ruby-echonest"
  gem.authors = ["youpy"]
end

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:core) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

task :default => :core

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "echonest %s" % Echonest::VERSION
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
