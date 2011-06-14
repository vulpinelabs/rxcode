module RXCode
module Spec
  
  module NSErrorHelpers
    
    def error_ptr
      @error_ptr ||= Pointer.new(:object)
    end
    
    def check_error_ptr!
      unless error_ptr[0].nil?
        fail error_ptr[0].localizedDescription
      end
    end
    
  end

end
end