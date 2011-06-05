module RXCode
module Commands
  
  class Gemify < ::RXCode::Command
    
    def targets
      self.arguments
    end
    
    def run!
      # determine the target...
      targets.each do |target|
        puts "Gemifying #{self.arguments.map(&:inspect).join(' ')}"
        
        # build the target...
        
        # copy the framework into the gem directory...
        
        # create a lib/TARGET_NAME.rb that loads the framework
        # create a gemspec
        
        # ...?
        
        # add
      end
    end
    
    def self.new_command_option_parser
      Trollop::Parser.new do
        banner <<-TEXT
Packages a Cocoa framework or iOS static library as a ruby gem

Usage:
  #{$0} [global options] gemify [options] TARGET ...

Options:
        TEXT
      end
    end

    
  end
  
end
end