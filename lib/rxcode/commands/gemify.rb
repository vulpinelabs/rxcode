module RXCode
module Commands
  
  class Gemify < ::RXCode::Command
    
    def target
      options[:target]
    end
    
    def run!
      # determine the target...
      puts "Gemifying #{self.target.inspect}..."
      
      # build the target...
      # copy the framework into the gem directory...
      # create a lib/TARGET_NAME.rb that loads the framework
      # create a gemspec
      # ...?
      # add
    end
    
    def self.new_command_option_parser
      Trollop::Parser.new do
        banner <<-TEXT
Packages a Cocoa framework or iOS static library as a ruby gem

Usage:
  #{$0} [global options] gemify [options]

Options:
        TEXT
        
        opt :target, "Name of the target to gemify",
            :type => String
        
      end
    end

    
  end
  
end
end