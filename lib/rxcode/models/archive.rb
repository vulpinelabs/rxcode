module RXCode
  
  #
  # Processes an NSKeyedArchive file into a set of Ruby objects
  #
  class Archive
    
    def initialize(archive_path_or_hash)
      if archive_path_or_hash.is_a?(String)
        
        if File.exist?(archive_path_or_hash)
          @archive_path = archive_path_or_hash
          @archive_hash = Plist::parse_xml(`plutil -convert xml1 -o - '#{archive_path_or_hash}'`)
        else
          @archive_hash = Plist::parse_xml(archive_path_or_hash)
        end
        
      elsif archive_path_or_hash.is_a?(Hash)
        
        @archive_hash = archive_path_or_hash
        
      end
      
      @objects = {}
    end
    
    # ===== ARCHIVE PATH ===============================================================================================
    
    attr_reader :archive_path
    
    attr_reader :archive_hash
    
    # ===== ROOT OBJECT ================================================================================================
    
    def root_object_archive_id
      @archive_hash['rootObject']
    end
    
    def root_object
      object_with_id(root_object_archive_id)
    end
    
    # ===== OBJECTS ====================================================================================================
    
    def object_with_id(object_id)
      @objects[object_id] ||=
        if object_hashes[object_id]
          ArchivedObject.new(self, object_id)
        end
    end
    
    def object_hashes
      archive_hash['objects']
    end
    
    def self.archive_at_path(archive_path)
      self.new(archive_path)
    end
    
    #
    # Returns the object archived in the file identified by +archive_path+.
    #
    def self.object_at_path(archive_path)
      archive_at_path(archive_path).root_object
    end
    
  end
  
end