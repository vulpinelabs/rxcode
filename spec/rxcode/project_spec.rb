require "spec_helper"
require 'tmpdir'
require "fileutils"

describe RXCode::Project do
  
  # ===== PROJECT DISCOVERY ============================================================================================
  
  describe ".find_project_paths_with_path" do
    
    before(:each) do
      @base_path = Dir.mktmpdir('rxcode')
      @project_path = File.join(@base_path, 'RXCode.xcodeproj')
      
      Dir.mkdir(@project_path)
      
      @file_path = File.join(@base_path, 'README')
      FileUtils.touch(@file_path)
      
      @directory_path = File.join(@base_path, 'spec')
      Dir.mkdir(@directory_path)
      
      @other_project_path = File.join(@base_path, 'Spectastic.xcodeproj')
      Dir.mkdir(@other_project_path)
    end
    
    after(:each) do
      FileUtils.rm_rf(@base_path)
    end
    
    describe "when the path is an .xcodeproj directory" do
      
      it "should return the directory path itself" do
        RXCode::Project.find_project_paths_with_path(@project_path).should == [ @project_path ]
      end
      
    end
    
    describe "when the path is a directory containing .xcodeproj directories" do
      
      it "should return all project paths" do
        RXCode::Project.find_project_paths_with_path(@base_path).should == [ @project_path, @other_project_path ]
      end
      
    end
    
    describe "when the path is a file within a directory containing multiple .xcodeproj directories" do
      
      it "should return all project paths in the same directory" do
        RXCode::Project.find_project_paths_with_path(@file_path).should == [ @project_path, @other_project_path ]
      end
      
    end
    
    describe "when no siblings are xcode projects" do
      
      before(:each) do
        @spec_file_path = File.join(@directory_path, 'spec_helper.rb')
        FileUtils.touch(@spec_file_path)
      end
      
      it "should search its ancestor paths for projects" do
        RXCode::Project.find_project_paths_with_path(@spec_file_path).should == [ @project_path, @other_project_path ]
      end
      
    end
    
  end
  
  # ===== PROJECT ARCHIVE ==============================================================================================
  
  describe "#unwrapped_project_data" do
    
    before(:each) do
      @project = RXCode::Fixtures.project_named('EmptyCocoaProject')
    end
    
    it "should unarchive the project data at the given path" do
      @project.unwrapped_project_data.should == {
          "buildConfigurationList"=> {
            "buildConfigurations" => [
              {"buildSettings"=>{}, "isa"=>"XCBuildConfiguration", "name"=>"Debug"},
              {"buildSettings"=>{}, "isa"=>"XCBuildConfiguration", "name"=>"Release"}
            ],
            "defaultConfigurationIsVisible"=>"0",
            "defaultConfigurationName"=>"Release",
            "isa"=>"XCConfigurationList"
          },
          "compatibilityVersion"=>"Xcode 3.2",
          "developmentRegion"=>"English",
          "hasScannedForEncodings"=>"0",
          "isa"=>"PBXProject",
          "knownRegions"=>["en"],
          "mainGroup"=> { "children"=>[], "isa"=>"PBXGroup", "sourceTree"=>"<group>" },
          "projectDirPath"=>"",
          "projectRoot"=>"",
          "targets"=>[]
        }
    end
    
  end
  
  # ===== TARGETS ======================================================================================================
  
  describe "#target_names" do
    
    describe "when the project contains one or more targets" do
      
      before(:each) do
        @project = RXCode::Fixtures.project_named('CocoaProjectWithFrameworkAndTests')
      end
      
      it "should return the names of all targets in the project" do
        @project.target_names.should == %w[MyFramework MyFrameworkTests]
      end
      
    end
    
    describe "when the project is empty" do
      
      before(:each) do
        @project = RXCode::Fixtures.project_named('EmptyCocoaProject')
      end
      
      it "should return an empty array" do
        @project.target_names.should == []
      end
      
    end
    
  end
  
end