require "spec_helper"

describe RXCode::Archive do
  
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
  
  # ===== ROOT OBJECT ==================================================================================================
  
  describe "#root_object_archive_id" do
    
    it "should return the ID of the root object" do
      @archive.root_object_archive_id.should == '62FC984713834C170015526D'
    end
    
  end
  
  describe "#root_object" do
    
    it "should return an RXCode::ArchivedObject for the root ID" do
      @archive.root_object.archived_object_id.should == '62FC984713834C170015526D'
    end
    
  end
  
  # ===== OBJECTS ======================================================================================================
  
  describe "#object_with_id" do
    
    describe "when the ID exists" do
      
      it "should return the object with that id" do
        object = @archive.object_with_id('62FC984713834C170015526E')
        object.archived_object_id.should == '62FC984713834C170015526E'
      end
      
    end
    
    describe "when the ID doesn't exist" do
      
      it "should return nil" do
        @archive.object_with_id('sdfsdfs').should be_nil
      end
      
    end
    
    describe "when called multiple times" do
      
      it "should always return the same instance" do
        object = @archive.object_with_id('62FC984713834C170015526E')
        @archive.object_with_id('62FC984713834C170015526E').should equal(object)
      end
      
    end
    
  end
  
  # describe "#unwrap_object_with_id" do
  #   
  #   describe "when the object contains an object ID" do
  #     
  #     it "should resolve that ID" do
  #       @archive.unwrap_object_with_id('62FC984713834C170015526C').should ==
  #         {
  #           'name' => 'Abe Froman',
  #           'email' => 'abe@sausageking.com',
  #           'isa' => 'Person',
  #           'assistant' => {
  #             'name' => 'Christian Niles',
  #             'email' => 'christian@nerdyc.com',
  #             'isa' => 'Person'
  #           }
  #         }
  #     end
  #     
  #   end
  #   
  #   describe "when the object contains an array of object IDs" do
  #     
  #     it "should resolve each item in the array" do
  #       
  #       @archive.unwrap_object_with_id('62FC984713834C170015526D').should ==
  #         {
  #           'isa' => 'ContactGroup',
  #           'contacts' => [ 
  #             {
  #               'name' => 'Christian Niles',
  #               'email' => 'christian@nerdyc.com',
  #               'isa' => 'Person'
  #             },
  #             {
  #               'name' => 'Abe Froman',
  #               'email' => 'abe@sausageking.com',
  #               'isa' => 'Person',
  #               'assistant' => {
  #                 'name' => 'Christian Niles',
  #                 'email' => 'christian@nerdyc.com',
  #                 'isa' => 'Person'
  #               }
  #             }
  #           ]
  #         }
  #       
  #     end
  #     
  #   end
  #   
  #   describe "when the object has already been unwrapped" do
  #     
  #     before(:each) do
  #       @unwrapped_object = @archive.unwrap_object_with_id('62FC984713834C170015526B')
  #     end
  #     
  #     it "should return the previously unwrapped value" do
  #       @archive.unwrap_object_with_id('62FC984713834C170015526B').should equal(@unwrapped_object)
  #     end
  #     
  #   end
  #   
  #   describe "when the object references itself" do
  #     
  #     it "should resolve itself properly" do
  #       object = @archive.unwrap_object_with_id('62FC984713834C170015526E')
  #       object.keys.should == ['isa', 'self']
  #       object['self'].should equal(object)
  #     end
  #     
  #   end
  #   
  #   describe "when the object doesn't exist" do
  #     
  #     it "should return nil" do
  #       @archive.unwrap_object_with_id('sdfsf').should == nil
  #     end
  #     
  #   end
  #   
  # end
  
end