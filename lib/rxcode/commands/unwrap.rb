module RXCode
module Commands
  
  class Unwrap < ::RXCode::Command
    
    def run!
      require 'pp'
      
      arguments.each do |filename|
        unwrapped_data = ::RXCode::Unwrapper.unwrap_object_at_path(filename)
        
        PP.pp(unwrapped_data, output)
      end
    end
    
    def self.new_command_option_parser
      Trollop::Parser.new do
        banner <<-TEXT
Unwraps archive files, in particular the project.pbxproj file, and prints their contents to standard out as a ruby hash.

Usage:
  #{$0} [global options] unwrap [options] FILENAME...

Options:
        TEXT
      end
    end
  end
  
end
end