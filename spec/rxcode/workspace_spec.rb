require 'spec_helper'
require 'tmpdir'

describe RXCode::Workspace do
  
  before(:each) do
    @workspace_dir = Dir.mktmpdir('TestWorkspace')
  end
  
  after(:each) do
    FileUtils.rm_rf(@workspace_dir)
  end
  
  # ===== PATHS ========================================================================================================
  
  describe "#root" do
    
    it "should return the workspace directory's parent when the workspace is independent" do
      workspace = RXCode::Fixtures.any_workspace
      workspace.root.should == File.dirname(workspace.path)
    end
    
    it "should return the project's directory when the workspace is dependent" do
      workspace = RXCode::Fixtures.dependent_workspace
      workspace.root.should == File.expand_path('../..', workspace.path)
    end
    
  end
  
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
  
  describe "#project_dependent?" do
    
    it "should return true when the workspace is project-dependent" do
      project_path = RXCode::Fixtures.path_of_project('EmptyCocoaProject')
      workspace_path = File.join(project_path, 'project.xcworkspace')
      
      RXCode::Workspace.new(workspace_path).should be_project_dependent
    end
    
    it "should return false when the workspace is not specific to a single project" do
      workspace = RXCode::Fixtures.any_workspace
      workspace.should_not be_project_dependent
    end
    
  end
  
  describe "#projects" do
    
    describe "when workspace is project-independent" do
      
      it "should return an array of RXCode::Project objects representing the projects it contains" do
        workspace = RXCode::Fixtures.workspace_named('SingleProjectWorkspace')
        workspace.projects.length.should == 1
        workspace.projects.first.path.should == File.expand_path('../FirstProject/FirstProject.xcodeproj', workspace.path)
      end
      
      it "should return an empty array when the workspace is empty" do
        RXCode::Fixtures.empty_workspace.projects.should be_empty
      end
      
    end
    
    describe "when workspace is project-dependent" do
      
      before(:each) do
        @workspace = RXCode::Fixtures.dependent_workspace
        @project_path = File.dirname(@workspace.path)
      end
      
      it "should return an array with only the enclosing project" do
        @workspace.projects.length.should == 1
        @workspace.projects.first.path.should == @project_path
      end
      
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
  
  # ===== SETTINGS =====================================================================================================
  
  describe "<settings>" do
    
    before(:each) do
      @workspace_path = File.join(@workspace_dir, 'TestWorkspace.xcworkspace')
      RXCode::Fixtures.init_empty_workspace(@workspace_path)
      
      @workspace = RXCode::Workspace.new(@workspace_path)
      
      @shared_settings = {
        'IDEWorkspaceSharedSettings_AutocreateContextsIfNeeded' => true
      }
      
      FileUtils.mkdir_p(File.dirname(@workspace.shared_settings_file))
      File.open(@workspace.shared_settings_file, 'w') do |f|
        f << @shared_settings.to_plist
      end
      
      @user_settings = {
        'IDEWorkspaceSharedSettings_AutocreateContextsIfNeeded' => false,
        'IDEWorkspaceUserSettings_BuildLocationStyle' => 0,
        'IDEWorkspaceUserSettings_BuildSubfolderNameStyle' => 0,
        'IDEWorkspaceUserSettings_DerivedDataLocationStyle' => 0,
        'IDEWorkspaceUserSettings_HasAskedToTakeAutomaticSnapshotBeforeSignificantChanges' => true,
        'IDEWorkspaceUserSettings_LiveSourceIssuesEnabled' => true,
        'IDEWorkspaceUserSettings_SnapshotAutomaticallyBeforeSignificantChanges' => false,
        'IDEWorkspaceUserSettings_SnapshotLocationStyle' => 0
      }
      
      user_settings_file = @workspace.settings_file_for_user('cniles')
      FileUtils.mkdir_p(File.dirname(user_settings_file))
      File.open(user_settings_file, 'w') do |f|
        f << @user_settings.to_plist
      end
    end
    
    describe "#shared_settings" do
      
      it "should return the shared workspace settings" do
        @workspace.shared_settings.should == @shared_settings
      end
    
    end
    
    describe "#settings_for_user" do
      
      it "should return the user-specific workspace settings" do
        @workspace.settings_for_user('cniles').should == @user_settings
      end
      
    end
    
  end
  
  # ===== DERIVED DATA LOCATION ========================================================================================
  
  describe "#derived_data_location" do
    
    describe "when the user has set a custom location setting" do
      
      before(:each) do
        @workspace_path = File.join(@workspace_dir, 'TestWorkspace.xcworkspace')
        RXCode::Fixtures.init_empty_workspace(@workspace_path)
        
        @workspace = RXCode::Workspace.new(@workspace_path)
        
        @user_settings = {
          'IDEWorkspaceUserSettings_DerivedDataCustomLocation' => 'DerivedData',
          'IDEWorkspaceUserSettings_DerivedDataLocationStyle' => 2
        }
      
        user_settings_file = @workspace.settings_file_for_user(ENV['USER'])
        FileUtils.mkdir_p(File.dirname(user_settings_file))
        File.open(user_settings_file, 'w') do |f|
          f << @user_settings.to_plist
        end
        
      end
      
      it "should return the custom location" do
        @workspace.derived_data_location.should == File.join(@workspace.root, 'DerivedData')
      end
      
    end
    
  end
  
end