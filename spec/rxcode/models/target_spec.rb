require "spec_helper"

describe RXCode::Target do
  
  # ===== PRODUCT TYPE =================================================================================================
  
  describe "#framework?" do
    
    before(:each) do
      @archive = RXCode::Archive.new({
        'objects' => {
          '62FC984713834C170015526D' => {
            "productType"=>"com.apple.product-type.framework"
          },
          '62FC984713834C170015526C' => {
            "productType"=>"com.apple.product-type.application"
          }
        },
        'rootObject' => '62FC984713834C170015526D'
      })
      @framework_target   = RXCode::Target.new(@archive.object_with_id('62FC984713834C170015526D'))
      @application_target = RXCode::Target.new(@archive.object_with_id('62FC984713834C170015526C'))
    end
    
    it "should return true when the product_type is 'com.apple.product-type.framework'" do
      @framework_target.should be_framework
    end
    
    it "should return no when the target is not a framework" do
      @application_target.should_not be_framework
    end
    
  end
  
  # ===== BUILD CONFIGURATION LIST =====================================================================================
  
  describe "#build_configuration_list" do
    
    before(:each) do
      @project = RXCode::Fixtures.project_named('CocoaProjectWithFrameworkAndTests')
      @target = @project.targets.first
    end
    
    it "should return the project's BuildConfigurationList" do
      @target.build_configuration_list.should be_kind_of(RXCode::BuildConfigurationList)
      @target.build_configuration_list.default_configuration_name.should be_nil
    end
    
  end
  
end