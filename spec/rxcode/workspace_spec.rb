require 'spec_helper'

describe RXCode::Workspace do
  
  # ===== PATHS ========================================================================================================
  
  describe "#resolve_file_reference" do
    
    before(:each) do
      @workspace = RXCode::Fixtures.any_workspace
    end
    
    describe "when provided a container: reference" do
      
      it "should resolve it relative to the workspace's directory" do
        @workspace.resolve_file_reference("container:path/to/file").should ==
          File.expand_path(File.join(@workspace.path, '..', 'path/to/file'))
      end
      
    end
    
    describe "when provided a group: reference" do
      
      it "should resolve it relative to the workspace's directory" do
        @workspace.resolve_file_reference("group:path/to/file").should ==
          File.expand_path(File.join(@workspace.path, '..', 'path/to/file'))
      end
      
    end
    
  end
  
  # ===== PROJECTS =====================================================================================================
  
  describe "#projects" do
    
    it "should return an array of RXCode::Project objects representing the projects it contains" do
      workspace = RXCode::Fixtures.workspace_named('SingleProjectWorkspace')
      workspace.projects.length.should == 1
      workspace.projects.first.path.should == File.expand_path('../FirstProject/FirstProject.xcodeproj', workspace.path)
    end
    
    it "should return an empty array when the workspace is empty" do
      RXCode::Fixtures.workspace_named('EmptyWorkspace').projects.should be_empty
    end
    
  end
  
  # ===== WORKSPACE DISCOVERY ==========================================================================================
  
  describe ".is_workspace_at_path?" do
    
    describe "when provided an independent workspace path" do
      
      it "should return true" do
        workspace_path = RXCode::Fixtures.path_of_workspace('EmptyWorkspace')
        RXCode::Workspace.is_workspace_at_path?(workspace_path).should equal(true)
      end
      
    end
    
    describe "when provided a project-based workspace" do
      
      it "should return true" do
        project_path = RXCode::Fixtures.path_of_project('EmptyCocoaProject')
        workspace_path = File.join(project_path, 'project.xcworkspace')
        
        RXCode::Workspace.is_workspace_at_path?(workspace_path).should equal(true)
      end
      
    end
    
    describe "when provided a non-workspace path" do
      
      it "should return false" do
        project_path = RXCode::Fixtures.path_of_project('EmptyCocoaProject')
        
        RXCode::Workspace.is_workspace_at_path?(project_path).should equal(false)
      end
      
    end
    
  end
  
end