module RXCode
module Commands
  
  #
  # Displays information about the current XCode environment
  #
  class Env < ::RXCode::Command
    
    def self.display(root, output=$>)
      output.puts "[ #{root} ]"
      output.puts
      
      workspace_path = Workspace.path_of_workspace_from_path(root)
      output.puts "Workspace: #{workspace_path || '(none)'}"
      
      if workspace_path
        workspace = Workspace.new(workspace_path)
        output.puts "Build Location: #{workspace.build_location || '(none)'}"
        output.puts "Built Products: #{workspace.built_products_dir || '(none)'}"
      end
    end
    
    def run!
      if arguments.empty?
        self.class.display(Dir.pwd)
      else
        arguments.each do |root|
          self.class.display(File.expand_path(root))
        end
      end
    end
    
    def self.new_command_option_parser
      Trollop::Parser.new do
        banner <<-TEXT
Displays information about the current XCode environment, culled from the current directory.

Usage:
  #{$0} [global options] env [env_root]

Options:
        TEXT
      end
    end
    
  end

end
end