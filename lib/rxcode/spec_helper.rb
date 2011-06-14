begin
  require 'rubygems'
  require 'rspec'
rescue LoadError => e
  puts "RSpec not found. Install it to rxcode spec tasks"
end

require 'rxcode'
require 'rxcode/spec/nserror_helpers'

module RSpec
  module Core
    class ExampleGroup
      
      include RXCode::Spec::NSErrorHelpers
      
    end
  end
end