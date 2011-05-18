require "spec_helper"

describe RXCode::Unwrapper do
  
  describe "#unwrap_object_with_id" do
    
    before(:each) do
      @unwrapper = RXCode::Unwrapper.new({
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
    
    describe "when the object contains an object ID" do
      
      it "should resolve that ID" do
        @unwrapper.unwrap_object_with_id('62FC984713834C170015526C').should ==
          {
            'name' => 'Abe Froman',
            'email' => 'abe@sausageking.com',
            'isa' => 'Person',
            'assistant' => {
              'name' => 'Christian Niles',
              'email' => 'christian@nerdyc.com',
              'isa' => 'Person'
            }
          }
      end
      
    end
    
    describe "when the object contains an array of object IDs" do
      
      it "should resolve each item in the array" do
        
        @unwrapper.unwrap_object_with_id('62FC984713834C170015526D').should ==
          {
            'isa' => 'ContactGroup',
            'contacts' => [ 
              {
                'name' => 'Christian Niles',
                'email' => 'christian@nerdyc.com',
                'isa' => 'Person'
              },
              {
                'name' => 'Abe Froman',
                'email' => 'abe@sausageking.com',
                'isa' => 'Person',
                'assistant' => {
                  'name' => 'Christian Niles',
                  'email' => 'christian@nerdyc.com',
                  'isa' => 'Person'
                }
              }
            ]
          }
        
      end
      
    end
    
    describe "when the object has already been unwrapped" do
      
      before(:each) do
        @unwrapped_object = @unwrapper.unwrap_object_with_id('62FC984713834C170015526B')
      end
      
      it "should return the previously unwrapped value" do
        @unwrapper.unwrap_object_with_id('62FC984713834C170015526B').should equal(@unwrapped_object)
      end
      
    end
    
    describe "when the object references itself" do
      
      it "should resolve itself properly" do
        object = @unwrapper.unwrap_object_with_id('62FC984713834C170015526E')
        object.keys.should == ['isa', 'self']
        object['self'].should equal(object)
      end
      
    end
    
    describe "when the object doesn't exist" do
      
      it "should return nil" do
        @unwrapper.unwrap_object_with_id('sdfsf').should == nil
      end
      
    end
    
  end
  
end