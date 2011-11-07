require 'rubygems'
require 'rake'

begin
  $LOAD_PATH.unshift "lib"
  require 'echonest'
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "ruby-echonest"
    gem.version = Echonest::VERSION
    gem.summary = "An Ruby interface for Echo Nest Developer API"
    gem.description = "An Ruby interface for Echo Nest Developer API"
    gem.email = "youpy@buycheapviagraonlinenow.com"
    gem.homepage = "http://github.com/youpy/ruby-echonest"
    gem.authors = ["youpy"]
    gem.add_development_dependency "rspec", ">= 2.0.0"
    gem.add_dependency "httpclient"
    gem.add_dependency "hashie"
    gem.add_dependency "libxml-ruby"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:core) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

task :core => :check_dependencies
task :default => :core

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "echonest %s" % Echonest::VERSION
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
