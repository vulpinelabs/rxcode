module RXCode
  
  #
  # Processes an NSKeyedArchive file into a set of Ruby objects
  #
  class Unwrapper
    
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
    
    # ===== ROOT OBJECT ================================================================================================
    
    def root_object_id
      @archive_hash['rootObject']
    end
    
    #
    # Returns the root object from the archive.
    #
    def root_object
      object_with_id(root_object_id)
    end
    
    def root_object_hash
      object_hashes[root_object_id]
    end
    
    # ===== OBJECTS ====================================================================================================
    
    def object_with_id(object_id)
      @objects[object_id] ||= unwrap_object_with_id(object_id)
    end
    
    def object_hashes
      @archive_hash['objects']
    end
    
    def unwrap_object_value(object_value)
      if object_value.is_a?(String) && object_hashes.has_key?(object_value)
        unwrap_object_with_id(object_value)
      elsif object_value.is_a?(Array) && object_value.all? { |array_member| object_hashes.has_key?(array_member) }
        object_value.map { |array_member| unwrap_object_with_id(array_member) }
      else
        object_value
      end
    end
    
    def unwrap_object_with_id(object_id)
      if @objects.has_key?(object_id)
        
        @objects[object_id]
        
      elsif object_hash = object_hashes[object_id]
        
        unwrapped_object = {}
        @objects[object_id] = unwrapped_object
        
        object_hash.each do |object_key, object_value|
          unwrapped_object[object_key] = unwrap_object_value(object_value)
        end
        
        unwrapped_object
      end
    end
    
    #
    # Returns the object archived in the file identified by +archive_path+.
    #
    def self.unwrap_object_at_path(archive_path)
      self.new(archive_path).root_object
    end
    
  end
  
end