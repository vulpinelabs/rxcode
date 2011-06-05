require "spec_helper"
require 'tmpdir'
require "fileutils"

describe RXCode::Project do
  
  # ===== BUILD CONFIGURATION LIST =====================================================================================
  
  describe "#build_configuration_list" do
    
    before(:each) do
      @project = RXCode::Fixtures.project_named('CocoaProjectWithFrameworkAndTests')
    end
    
    it "should return the project's BuildConfigurationList" do
      @project.build_configuration_list.should be_kind_of(RXCode::BuildConfigurationList)
      @project.build_configuration_list.default_configuration_name.should == "Release"
    end
    
  end
  
  # ===== TARGETS ======================================================================================================
  
  describe "#targets" do
    
    describe "when the project contains one or more targets" do
      
      before(:each) do
        @project = RXCode::Fixtures.project_named('CocoaProjectWithFrameworkAndTests')
      end
      
      it "should return an array of all targets in the project" do
        @project.targets.map(&:name).should == %w[MyFramework MyFrameworkTests]
      end
      
    end
    
    describe "when the project is empty" do
      
      before(:each) do
        @project = RXCode::Fixtures.project_named('EmptyCocoaProject')
      end
      
      it "should return an empty array" do
        @project.targets.should == []
      end
      
    end
    
  end
  
end