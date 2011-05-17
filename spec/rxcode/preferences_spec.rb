require 'spec_helper'

describe RXCode::Preferences do
  
  # ===== DERIVED DATA LOCATION ========================================================================================
  
  describe "#derived_data_location" do
    
    describe "when no IDECustomDerivedDataLocation value exists" do
      
      before(:each) do
        @preferences = RXCode::Preferences.new({})
      end
      
      it "should return ~/Library//Developer/Xcode/DerivedData" do
        @preferences.derived_data_location.should == File.expand_path("~/Library/Developer/Xcode/DerivedData")
      end
      
    end
    
    describe "when an IDECustomDerivedDataLocation is set" do
      
      before(:each) do
        @preferences = RXCode::Preferences.new('IDECustomDerivedDataLocation' => "/Users/username/build")
      end
      
      it "should return it" do
        @preferences.derived_data_location.should == "/Users/username/build"
      end
      
    end
    
  end
  
  describe "derived_data_location_is_relative_to_workspace?" do
    
    it "should be true when derived_data_location is relative" do
      p = RXCode::Preferences.new('IDECustomDerivedDataLocation' => "DerivedData")
      p.derived_data_location_is_relative_to_workspace?.should == true
    end
    
    it "should be false when derived_data_location is absolute" do
      p = RXCode::Preferences.new('IDECustomDerivedDataLocation' => "/Users/username/build")
      p.derived_data_location_is_relative_to_workspace?.should == false
    end
    
  end
  
end