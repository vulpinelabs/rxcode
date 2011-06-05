module RXCode
  
  class Model
    
    def initialize(source)
      case source
      when ArchivedObject, NilClass
        @archive_object = source
      when Archive
        @archive_object = source.root_object
      when String, Hash
        archive = Archive.new(source)
        @archive_object = archive.rootObject
      else
        raise "Unable to initialize #{self.class.name} from #{source.class.name}: #{source.inspect}"
      end
    end
    
    # ===== ARCHIVE ====================================================================================================
    
    attr_reader :archive_object
    
    def archive
      archive_object.archive
    end
    
  end
  
end