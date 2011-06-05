module RXCode
  
  class ArchivedObject
    
    def initialize(archive, archived_object_id)
      @archive = archive
      @archived_object_id = archived_object_id
    end
    
    # ===== ARCHIVE ====================================================================================================
    
    attr_reader :archive
    
    # ===== ARCHIVE OBJECT ID ==========================================================================================
    
    attr_reader :archived_object_id
    
    # ===== DATA =======================================================================================================
    
    def data
      @data ||= archive.object_hashes[self.archived_object_id]
    end
    
    def [](key)
      data[key]
    end
    
    def has_key?(key)
      data.has_key?(key)
    end
    
    def object_for_key(key)
      object_id = self[key]
      archive.object_with_id(object_id)
    end
    
    def array_of_objects_for_key(key)
      self[key].map { |object_id| archive.object_with_id(object_id) }
    end
    
  end
  
end