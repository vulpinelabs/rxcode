# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "rxcode"
  gem.homepage = "http://github.com/vulpinelabs/rxcode"
  gem.license = "MIT"
  gem.summary = %Q{A Ruby interface for working with XCode projects.}
  gem.description = %Q{A Ruby interface for working with XCode projects.}
  gem.email = "christian@nerdyc.com"
  gem.authors = ["Christian Niles"]
  
  gem.files = FileList[ 'lib/**/*.rb',
                        'lib/rxcode/templates/**',
                        'lib/rxcode/templates/spec/support/.gitkeep',
                        'bin/*',
                        '[A-Z]*'
                        
                        ].to_a - %w[Gemfile.lock]
  gem.executables << 'rxcode'
  
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rxcode #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
