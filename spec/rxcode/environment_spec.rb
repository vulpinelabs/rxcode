require "spec_helper"
require 'tmpdir'
require 'fileutils'

describe RXCode::Environment do
  
  before(:each) do
    @temp_dir = Dir.mktmpdir('rxcode_env')
    
    @env_root = File.join(@temp_dir, 'RXCodeEnv')
    FileUtils.mkdir_p(@env_root)
    
    @env = RXCode::Environment.new(@env_root)
  end
  
  after(:each) do
    FileUtils.rm_rf(@temp_dir)
  end
  
  # ===== WORKSPACE ====================================================================================================
  
  describe "#workspace_path" do
    
    describe "when the env root contains a single workspace" do
      
      before(:each) do
        @workspace_path = File.join(@env_root, 'MyWorkspace.xcworkspace')
        RXCode::Fixtures.init_empty_workspace(@workspace_path)
      end
      
      it "should return the workspace's path" do
        @env.workspace_path.should == @workspace_path
      end
      
    end
    
    describe "when the env root contains multiple workspaces" do
      
      before(:each) do
        @other_workspace_path = File.join(@env_root, "OtherWorkspace.xcworkspace")
        RXCode::Fixtures.init_empty_workspace(@other_workspace_path)
      end
      
      describe "if one of them matches the name of the root directory" do
        
        before(:each) do
          @workspace_path = File.join(@env.root, "#{@env.name}.xcworkspace")
          RXCode::Fixtures.init_empty_workspace(@workspace_path)
        end
        
        it "should return that workspace's path" do
          @env.workspace_path.should == @workspace_path
        end
        
      end
      
      describe "and none match the name of the root directory" do
        
        before(:each) do
          @workspace_path = File.join(@env_root, "MyWorkspace.xcworkspace")
          RXCode::Fixtures.init_empty_workspace(@workspace_path)
        end
        
        it "should return nil" do
          @env.workspace_path.should be_nil
        end
        
      end
      
    end
    
    describe "when the env root does not contain a workspace" do
      
      describe "but contains a single project" do
        
        before(:each) do
          @project_path = File.join(@env_root, "MyProject.xcodeproj")
          RXCode::Fixtures.init_empty_project(@project_path)
        end
        
        it "should return the project-specific workspace's path" do
          @env.workspace_path.should == File.join(@project_path, 'project.xcworkspace')
        end
        
      end
      
      describe "but contains multiple projects" do
        
        before(:each) do
          @other_project_path = File.join(@env_root, "MyProject.xcodeproj")
          RXCode::Fixtures.init_empty_project(@other_project_path)
        end
        
        describe "and one matches the environment name" do
          
          before(:each) do
            @project_path = File.join(@env_root, "#{@env.name}.xcodeproj")
            RXCode::Fixtures.init_empty_project(@project_path)
          end
          
          it "should return that project's workspace" do
            @env.workspace_path.should == File.join(@project_path, 'project.xcworkspace')
          end
          
        end
        
        describe "and none of them match the environment name" do
          
          before(:each) do
            @project_path = File.join(@env_root, "MyOtherProject.xcodeproj")
            RXCode::Fixtures.init_empty_project(@project_path)
          end
          
          it "should return nil" do
            @env.workspace_path.should be_nil
          end
          
        end
        
      end
      
      describe "and does not contain any projects" do
        
        it "should return nil" do
          @env.workspace_path.should be_nil
        end
        
      end
      
    end
    
  end
  
end