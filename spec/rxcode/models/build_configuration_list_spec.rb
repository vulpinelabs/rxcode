require "spec_helper"

describe RXCode::BuildConfigurationList do
  
  before(:each) do
    @project = RXCode::Fixtures.project_named('CocoaProjectWithFrameworkAndTests')
    @build_configuration_list = @project.build_configuration_list
  end
  
  # ===== DEFAULT CONFIGURATION NAME ===================================================================================
  
  describe "#default_configuration_name" do
    
    it "should return the defaultConfigurationName value" do
      @build_configuration_list.default_configuration_name.should == "Release"
    end
    
  end
  
  # ===== BUILD CONFIGURATIONS =========================================================================================
  
  describe "#build_configurations" do
    
    before(:each) do
      @build_configurations = @build_configuration_list.build_configurations
    end
    
    it "should return an array of all BuildConfiguration instances" do
      @build_configurations.should be_kind_of(Array)
      @build_configurations.length.should == 2
      @build_configurations.collect { |bc| bc.class.name }.should == [ "RXCode::BuildConfiguration" ] * 2
    end
    
  end
  
end