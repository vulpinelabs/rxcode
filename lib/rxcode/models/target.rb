module RXCode
  
  class Target < Model
    
    def project
      self.archive.root_object.model_object
    end
    
    # ===== NAME =======================================================================================================
    
    def name
      archive_object['name']
    end
    
    # ===== PRODUCT ====================================================================================================
    
    def product_name
      archive_object['productName']
    end
    
    def product_reference
      archive_object.model_object_for_key('productReference')
    end
    
    # ===== PRODUCT TYPE ===============================================================================================
    
    def product_type
      archive_object['productType']
    end
    
    def framework?
      product_type == 'com.apple.product-type.framework'
    end
    
    def application?
      product_type == 'com.apple.product-type.application'
    end
    
    def bundle?
      product_type == 'com.apple.product-type.bundle'
    end
    
    # ===== BUILD CONFIGURATIONS =======================================================================================
    
    def build_configuration_list
      archive_object.model_object_for_key('buildConfigurationList')
    end
    
  end
  
end