require "spec_helper"

describe RXCode::ArchivedObject do
  
  before(:each) do
    @archive = RXCode::Archive.new({
      'objects' => {
        '62FC984713834C170015526B' => {
          'name' => 'Christian Niles',
          'email' => 'christian@nerdyc.com',
          'isa' => 'Person'
        },
        '62FC984713834C170015526C' => {
          'name' => 'Abe Froman',
          'email' => 'abe@sausageking.com',
          'isa' => 'Person',
          'assistant' => '62FC984713834C170015526B'
        },
        '62FC984713834C170015526D' => {
          'isa' => 'ContactGroup',
          'contacts' => [ '62FC984713834C170015526B', '62FC984713834C170015526C' ]
        },
        '62FC984713834C170015526E' => {
          'isa' => 'Loop',
          'self' => '62FC984713834C170015526E'
        }
      },
      'rootObject' => '62FC984713834C170015526D'
    })
  end
  
  # ===== DATA =========================================================================================================
  
  describe "#[]" do
    
    it "should return the raw value of the key" do
      @archive.root_object['isa'].should == 'ContactGroup'
    end
    
  end
  
  describe "#has_key?" do
    
    it "should return true when the key exists" do
      @archive.root_object.has_key?('isa').should be_true
    end
    
    it "should return false when the key doesn't exist" do
      @archive.root_object.has_key?('ISA').should be_false
    end
    
  end
  
  describe "#object_for_key" do
    
    describe "when the key's value refers to an object" do
      
      before(:each) do
        @object = @archive.object_with_id('62FC984713834C170015526C')
      end
      
      it "should return that object" do
        keyed_object = @object.object_for_key('assistant')
        keyed_object.should be_kind_of(RXCode::ArchivedObject)
        keyed_object.archived_object_id.should == '62FC984713834C170015526B'
      end
      
    end
    
    describe "when the key's value is the same as the object's id" do
      
      before(:each) do
        @object = @archive.object_with_id('62FC984713834C170015526E')
      end
      
      it "should return the object itself" do
        @object.object_for_key('self').should equal(@object)
      end
      
    end
    
    
    describe "when the key's value doesn't refer to an object" do
      
      it "should return nil" do
        @archive.root_object.object_for_key('isa').should be_nil
      end
      
    end
    
    describe "when the key doesn't exist" do
      
      it "should return nil" do
        @archive.root_object.object_for_key('sdfsdf').should be_nil
      end
      
    end
    
  end
  
end