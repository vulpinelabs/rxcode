require "spec_helper"

describe RXCode::BuildConfiguration do
  
  before(:each) do
    @project = RXCode::Fixtures.project_named('CocoaProjectWithFrameworkAndTests')
    @build_configuration_list = @project.build_configuration_list
    @build_configuration = @build_configuration_list.build_configurations.first
  end
  
  # ===== NAME =========================================================================================================
  
  describe "#name" do
    
    it "should return the name of the configuration" do
      @build_configuration.name.should == 'Debug'
    end
    
  end
  
  # ===== BUILD SETTINGS ===============================================================================================
  
  describe "#build_settings" do
    
    it "should return a dictionary of build settings" do
      @build_configuration.build_settings.should == {}
    end
    
  end
  
end