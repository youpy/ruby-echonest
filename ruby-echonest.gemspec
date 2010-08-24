# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ruby-echonest}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["youpy"]
  s.date = %q{2010-08-24}
  s.description = %q{An Ruby interface for Echo Nest Developer API}
  s.email = %q{youpy@buycheapviagraonlinenow.com}
  s.extra_rdoc_files = ["README.rdoc", "ChangeLog"]
  s.files = ["README.rdoc", "ChangeLog", "Rakefile", "spec/analysis_spec.rb", "spec/api_spec.rb", "spec/echonest_spec.rb", "spec/fixtures", "spec/fixtures/analysis.json", "spec/fixtures/profile.json", "spec/fixtures/profile_failure.json", "spec/fixtures/profile_unknown.json", "spec/fixtures/sample.mp3", "spec/response_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/track_spec.rb", "lib/echonest", "lib/echonest/analysis.rb", "lib/echonest/api.rb", "lib/echonest/element", "lib/echonest/element/bar.rb", "lib/echonest/element/beat.rb", "lib/echonest/element/loudness.rb", "lib/echonest/element/section.rb", "lib/echonest/element/segment.rb", "lib/echonest/element/tatum.rb", "lib/echonest/response.rb", "lib/echonest/traditional_api_methods.rb", "lib/echonest/version.rb", "lib/echonest.rb"]
  s.homepage = %q{http://github.com/youpy/ruby-echonest}
  s.rdoc_options = ["--title", "ruby-echonest documentation", "--charset", "utf-8", "--opname", "index.html", "--line-numbers", "--main", "README.rdoc", "--inline-source", "--exclude", "^(examples|extras)/"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ruby-echonest}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{An Ruby interface for Echo Nest Developer API}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<libxml-ruby>, [">= 0"])
      s.add_runtime_dependency(%q<httpclient>, [">= 0"])
      s.add_runtime_dependency(%q<hashie>, [">= 0"])
    else
      s.add_dependency(%q<libxml-ruby>, [">= 0"])
      s.add_dependency(%q<httpclient>, [">= 0"])
      s.add_dependency(%q<hashie>, [">= 0"])
    end
  else
    s.add_dependency(%q<libxml-ruby>, [">= 0"])
    s.add_dependency(%q<httpclient>, [">= 0"])
    s.add_dependency(%q<hashie>, [">= 0"])
  end
end
