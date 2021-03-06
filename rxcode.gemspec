# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rxcode}
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Christian Niles"]
  s.date = %q{2011-06-14}
  s.description = %q{A Ruby interface for working with XCode projects.}
  s.email = %q{christian@nerdyc.com}
  s.executables = ["rxcode", "rxcode"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    "Gemfile",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "bin/rxcode",
    "lib/rxcode.rb",
    "lib/rxcode/command.rb",
    "lib/rxcode/commands.rb",
    "lib/rxcode/commands/env.rb",
    "lib/rxcode/commands/init.rb",
    "lib/rxcode/commands/unwrap.rb",
    "lib/rxcode/environment.rb",
    "lib/rxcode/macruby.rb",
    "lib/rxcode/models.rb",
    "lib/rxcode/models/archive.rb",
    "lib/rxcode/models/archived_object.rb",
    "lib/rxcode/models/build_configuration.rb",
    "lib/rxcode/models/build_configuration_list.rb",
    "lib/rxcode/models/file_reference.rb",
    "lib/rxcode/models/model.rb",
    "lib/rxcode/models/project.rb",
    "lib/rxcode/models/target.rb",
    "lib/rxcode/preferences.rb",
    "lib/rxcode/spec/nserror_helpers.rb",
    "lib/rxcode/spec/rake_ext.rb",
    "lib/rxcode/spec/rake_task.rb",
    "lib/rxcode/spec_helper.rb",
    "lib/rxcode/tasks.rb",
    "lib/rxcode/tasks/bridge_support.rb",
    "lib/rxcode/tasks/ios_framework.rb",
    "lib/rxcode/tasks/spec.rb",
    "lib/rxcode/templates/Gemfile",
    "lib/rxcode/templates/Rakefile",
    "lib/rxcode/templates/spec/spec_helper.rb",
    "lib/rxcode/templates/spec/support/.gitkeep",
    "lib/rxcode/workspace.rb"
  ]
  s.homepage = %q{http://github.com/vulpinelabs/rxcode}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{A Ruby interface for working with XCode projects.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<plist>, [">= 0"])
      s.add_runtime_dependency(%q<trollop>, [">= 0"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
      s.add_development_dependency(%q<gemcutter>, ["~> 0.7.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.2"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<plist>, [">= 0"])
      s.add_dependency(%q<trollop>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<gemcutter>, ["~> 0.7.0"])
      s.add_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.2"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<plist>, [">= 0"])
    s.add_dependency(%q<trollop>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<gemcutter>, ["~> 0.7.0"])
    s.add_dependency(%q<rspec>, ["~> 2.6.0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.2"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end

