module RXCode
  
  class FileReference < Model
    
    def name
      archive_object['name']
    end
    
    def path
      archive_object['path']
    end
    
    def source_tree
      archive_object['sourceTree']
    end
    
    def last_known_file_type
      archive_object['lastKnownFileType']
    end
    
  end
  
end