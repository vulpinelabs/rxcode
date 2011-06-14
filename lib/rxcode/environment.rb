module RXCode
  
  #
  # Represents an XCode environment rooted at a particular path in a filesystem -- typically a project/workspace root
  # directory.
  #
  class Environment
    
    def initialize(root)
      @root = root
      @preferences = Preferences.new
    end
    
    # ===== ROOT =======================================================================================================
    
    attr_reader :root
    
    def name
      File.basename(root)
    end
    
    # ===== PREFERENCES ================================================================================================
    
    attr_reader :preferences
    
    # ===== DERIVED DATA ===============================================================================================
    
    def global_derived_data_location
      self.preferences.derived_data_location unless preferences.derived_data_location_is_relative_to_workspace?
    end
    
    # ===== WORKSPACE ==================================================================================================
    
    def workspace
      @workspace ||=
        if ws_path = self.workspace_path
          Workspace.new(ws_path)
        end
    end
    
    def workspace_path
      workspace_paths = Dir[File.join(self.root, '*.xcworkspace')]
      preferred_workspace_path = File.join(root, "#{name}.xcworkspace")
      
      if workspace_paths.include?(preferred_workspace_path)
        
        preferred_workspace_path
        
      elsif workspace_paths.length == 1
        
        workspace_paths.first
        
      else
        project_paths = Dir[File.join(self.root, '*.xcodeproj')]
        preferred_project_path = File.join(root, "#{name}.xcodeproj")
        
        project_path =
          if project_paths.include?(preferred_project_path)
            preferred_project_path
          elsif project_paths.length == 1
            project_paths.first
          end
        
        if project_path
          project_workspace_path = File.join(project_path, 'project.xcworkspace')
          if RXCode::Workspace.is_workspace_at_path?(project_workspace_path)
            project_workspace_path
          end
        end
        
      end
    end
    
  end
  
  def self.env
    @env ||= Environment.new(Dir.pwd)
  end
  
end