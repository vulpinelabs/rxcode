require 'rxcode/spec/rake_ext'

begin
  require 'rspec/core/rake_task'
rescue LoadError => e
end

if defined?(::RSpec::Core::RakeTask)

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

end