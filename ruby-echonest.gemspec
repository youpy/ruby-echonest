# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ruby-echonest}
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["youpy"]
  s.date = %q{2009-09-23}
  s.description = %q{An Ruby interface for Echo Nest Developer API}
  s.email = %q{youpy@buycheapviagraonlinenow.com}
  s.extra_rdoc_files = ["README.rdoc", "ChangeLog"]
  s.files = ["README.rdoc", "ChangeLog", "Rakefile", "spec/api_spec.rb", "spec/echonest_spec.rb", "spec/fixtures", "spec/fixtures/get_bars.xml", "spec/fixtures/get_beats.xml", "spec/fixtures/get_duration.xml", "spec/fixtures/get_end_of_fade_in.xml", "spec/fixtures/get_key.xml", "spec/fixtures/get_loudness.xml", "spec/fixtures/get_metadata.xml", "spec/fixtures/get_mode.xml", "spec/fixtures/get_sections.xml", "spec/fixtures/get_segments.xml", "spec/fixtures/get_start_of_fade_out.xml", "spec/fixtures/get_tatums.xml", "spec/fixtures/get_tempo.xml", "spec/fixtures/get_time_signature.xml", "spec/fixtures/sample.mp3", "spec/response_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "lib/echonest", "lib/echonest/api.rb", "lib/echonest/element", "lib/echonest/element/bar.rb", "lib/echonest/element/beat.rb", "lib/echonest/element/loudness.rb", "lib/echonest/element/section.rb", "lib/echonest/element/segment.rb", "lib/echonest/element/tatum.rb", "lib/echonest/element/value_with_confidence.rb", "lib/echonest/response.rb", "lib/echonest/version.rb", "lib/echonest.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://ruby-echonest.rubyforge.org}
  s.rdoc_options = ["--title", "ruby-echonest documentation", "--charset", "utf-8", "--opname", "index.html", "--line-numbers", "--main", "README.rdoc", "--inline-source", "--exclude", "^(examples|extras)/"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ruby-echonest}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{An Ruby interface for Echo Nest Developer API}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<libxml-ruby>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
    else
      s.add_dependency(%q<libxml-ruby>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
    end
  else
    s.add_dependency(%q<libxml-ruby>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
  end
end
