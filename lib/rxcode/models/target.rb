module RXCode
  
  class Target < Model
    
    # ===== NAME =======================================================================================================
    
    def name
      archive_object['name']
    end
    
    # ===== PRODUCT ====================================================================================================
    
    def product_name
      archive_object['productName']
    end
    
    def product_reference
      archive_object['productReference']
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
    
  end
  
end