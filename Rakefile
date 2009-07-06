require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/contrib/sshpublisher'
require 'spec/rake/spectask'
require 'fileutils'
include FileUtils

$LOAD_PATH.unshift "lib"
require "echonest"

NAME              = "ruby-echonest"
AUTHOR            = "youpy"
EMAIL             = "youpy@buycheapviagraonlinenow.com"
DESCRIPTION       = "An Ruby interface for Echo Nest Developer API"
RUBYFORGE_PROJECT = "ruby-echonest"
HOMEPATH          = "http://#{RUBYFORGE_PROJECT}.rubyforge.org"
BIN_FILES         = %w(  )
VERS              = Echonest::VERSION

REV = File.read(".svn/entries")[/committed-rev="(d+)"/, 1] rescue nil
CLEAN.include ['**/.*.sw?', '*.gem', '.config']
RDOC_OPTS = [
  '--title', "#{NAME} documentation",
  "--charset", "utf-8",
  "--opname", "index.html",
  "--line-numbers",
  "--main", "README.rdoc",
  "--inline-source",
]

task :default => [:spec]
task :package => [:clean]

Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ['--options', "spec/spec.opts"]
  t.spec_files = FileList['spec/*_spec.rb']
  t.rcov = true
end

spec = Gem::Specification.new do |s|
  s.name              = NAME
  s.version           = VERS
  s.platform          = Gem::Platform::RUBY
  s.has_rdoc          = true
  s.extra_rdoc_files  = ["README.rdoc", "ChangeLog"]
  s.rdoc_options     += RDOC_OPTS + ['--exclude', '^(examples|extras)/']
  s.summary           = DESCRIPTION
  s.description       = DESCRIPTION
  s.author            = AUTHOR
  s.email             = EMAIL
  s.homepage          = HOMEPATH
  s.executables       = BIN_FILES
  s.rubyforge_project = RUBYFORGE_PROJECT
  s.bindir            = "bin"
  s.require_path      = "lib"
  s.test_files        = Dir["test/test_*.rb"]

  s.add_dependency('libxml-ruby')
  #s.required_ruby_version = '>= 1.8.2'

  s.files = %w(README.rdoc ChangeLog Rakefile) +
    Dir.glob("{bin,doc,spec,test,lib,templates,generator,extras,website,script}/**/*") + 
    Dir.glob("ext/**/*.{h,c,rb}") +
    Dir.glob("examples/**/*.rb") +
    Dir.glob("tools/*.rb")

  s.extensions = FileList["ext/**/extconf.rb"].to_a
end

Rake::GemPackageTask.new(spec) do |p|
  p.need_tar = true
  p.gem_spec = spec
end

task :install do
  name = "#{NAME}-#{VERS}.gem"
  sh %{rake package}
  sh %{sudo gem install pkg/#{name}}
end

task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{NAME}}
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'html'
  rdoc.options += RDOC_OPTS
  rdoc.template = "resh"
  #rdoc.template = "#{ENV['template']}.rb" if ENV['template']
  if ENV['DOC_FILES']
    rdoc.rdoc_files.include(ENV['DOC_FILES'].split(/,\s*/))
  else
    rdoc.rdoc_files.include('README', 'ChangeLog')
    rdoc.rdoc_files.include('lib/**/*.rb')
    rdoc.rdoc_files.include('ext/**/*.c')
  end
end

desc "Show information about the gem"
task :debug_gem do
  puts spec.to_ruby
end
