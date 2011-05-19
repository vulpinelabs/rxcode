module RXCode
module Commands
  
  #
  # Displays information about the current XCode environment
  #
  class Env < ::RXCode::Command
    
    def self.display(env, output=$>)
      output.puts "[ #{env.root} ]"
      output.puts
      workspace_path = env.workspace_path
      output.puts "Workspace: #{workspace_path || '(none)'}"
      output.puts "Build Location: #{env.workspace.build_location || '(none)'}"
      output.puts "Built Products: #{env.workspace.built_products_dir || '(none)'}"
    end
    
    def run!
      if arguments.empty?
        self.class.display(Dir.pwd)
      else
        arguments.each do |root|
          env = RXCode::Environment.new(File.expand_path(root))
          self.class.display(env)
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