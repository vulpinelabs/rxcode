require "spec_helper"
require 'tmpdir'
require "fileutils"

describe RXCode::Project do
  
  
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