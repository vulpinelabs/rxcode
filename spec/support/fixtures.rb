module RXCode
  
  module Fixtures
    
    # ===== PROJECTS ===================================================================================================
    
    PROJECT_FIXTURE_DIRECTORY = File.expand_path('../../fixtures/projects', __FILE__)
    
    def self.path_of_project(project_name)
      File.join(PROJECT_FIXTURE_DIRECTORY, project_name, "#{project_name}.xcodeproj")
    end
    
    def self.project_named(project_name)
      fixture_path = path_of_project(project_name)
      if RXCode::Project.is_project_at_path?(fixture_path)
        RXCode::Project.new(fixture_path)
      end
    end
    
    # ===== WORKSPACES =================================================================================================
    
    WORKSPACE_FIXTURE_DIRECTORY = File.expand_path('../../fixtures/workspaces', __FILE__)
    
    def self.path_of_workspace(workspace_name)
      File.join(WORKSPACE_FIXTURE_DIRECTORY, workspace_name, "#{workspace_name}.xcworkspace")
    end
    
    def self.workspace_named(workspace_name)
      fixture_path = path_of_workspace(workspace_name)
      
      RXCode::Workspace.new(fixture_path)
    end
    
    def self.workspace_paths
      Dir[File.join(WORKSPACE_FIXTURE_DIRECTORY, '*/*.xcworkspace')]
    end
    
    def self.any_workspace
      if workspace_path = workspace_paths.first
        RXCode::Workspace.new(workspace_path)
      end
    end
    
  end
  
end

