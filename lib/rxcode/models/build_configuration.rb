module RXCode
  
  class BuildConfiguration < Model
    
    # ===== NAME =======================================================================================================
    
    def name
      archive_object['name']
    end
    
    # ===== BUILD SETTINGS =============================================================================================
    
    def build_settings
      archive_object['buildSettings']
    end
    
  end
  
end