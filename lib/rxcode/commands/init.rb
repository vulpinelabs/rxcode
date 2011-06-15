module RXCode
module Commands
  
  #
  # Displays information about the current XCode environment
  #
  class Init < ::RXCode::Command
    
    def projects
      if arguments.empty?
        [ '.' ]
      else
        arguments
      end
    end
    
    TEMPLATE_FILES = [
        'Gemfile',
        'Rakefile',
        'spec/spec_helper.rb',
        'spec/support/.gitkeep'
      ]
    
    def run!
      
      templates_path = File.expand_path("../../templates", __FILE__)
      
      projects.each do |project_path|
        
        if RXCode::Project.is_project_at_path?(project_path) ||
            RXCode::Workspace.is_workspace_at_path?(project_path)
          
          project_path = File.dirname(project_path)
          
        end
        
        TEMPLATE_FILES.each do |template_name|
          template_path = File.join(templates_path, template_name)
          instance_path = File.join(project_path, template_name)
          
          if File.exist?(instance_path)
            
            output.puts "#{project_path.inspect} already exists"
            
          else
            # create any intermediate directories...
            FileUtils.mkdir_p(File.dirname(instance_path))
            
            # ...and copy the file contents
            FileUtils.cp(template_path, instance_path)
          end
        end
        
      end
      
    end
    
    def self.new_command_option_parser
      Trollop::Parser.new do
        banner <<-TEXT
Initializes the current project or workspace with RXCode.

Usage:
  #{$0} [global options] init

Options:
        TEXT
      end
    end
    
  end

end
end