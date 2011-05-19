require 'fileutils'

module RXCode
  
  module Fixtures
    
    # ===== PROJECTS ===================================================================================================
    
    PROJECT_FIXTURE_DIRECTORY = File.expand_path('../../fixtures/projects', __FILE__)
    
    def self.project_paths
      Dir[File.join(PROJECT_FIXTURE_DIRECTORY, '*/*.xcodeproj')]
    end
    
    def self.path_of_project(project_name)
      File.join(PROJECT_FIXTURE_DIRECTORY, project_name, "#{project_name}.xcodeproj")
    end
    
    def self.project_named(project_name)
      fixture_path = path_of_project(project_name)
      if RXCode::Project.is_project_at_path?(fixture_path)
        RXCode::Project.new(fixture_path)
      end
    end
    
    def self.any_project
      if project_path = project_paths.first
        RXCode::Workspace.new(workspace_path)
      end
    end
    
    def self.empty_project
      project_named('EmptyCocoaProject')
    end
    
    def self.init_empty_project(project_path)
      project_name = File.basename(project_path, '.xcodeproj')
      empty_project_dir = path_of_project('EmptyCocoaProject')
      
      FileUtils.mkdir_p(File.dirname(project_path))
      FileUtils.cp_r(empty_project_dir, project_path)
      
      ws_contents_path = File.join(project_path, 'project.xcworkspace', 'contents.xcworkspacedata')
      workspace_contents = File.read(ws_contents_path)
      
      workspace_contents.gsub!('EmptyCocoaProject', project_name)
      File.open(ws_contents_path, 'w') { |f| f << workspace_contents }
      
      project_name
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
    
    def self.empty_workspace
      workspace_named('EmptyWorkspace')
    end
    
    def self.dependent_workspace
      project_path = path_of_project('EmptyCocoaProject')
      
      RXCode::Workspace.new(File.join(project_path, 'project.xcworkspace'))
    end
    
    def self.init_empty_workspace(workspace_path)
      empty_workspace_dir = path_of_workspace('EmptyWorkspace')
      
      FileUtils.mkdir_p(File.dirname(workspace_path))
      FileUtils.cp_r(empty_workspace_dir, workspace_path)
    end
    
  end
  
end

