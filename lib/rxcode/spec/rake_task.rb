require 'rspec/core/rake_task'
require 'rxcode/spec/rake_ext'

module RXCode
module Spec
  
  class RakeTask < ::RSpec::Core::RakeTask
    
    def initialize(*args)
      super do |t|
        t.pattern = "./**/Specs/**/*_spec.rb"
        
        yield t if block_given?
      end
    end
    
  end

end
end