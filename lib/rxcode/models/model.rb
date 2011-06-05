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
      
      if @archive_object
        @archive_object.model_object = self
        @archive_object.archive.object_mapper ||=
          Proc.new { |archived_object| self.class.map_archived_object(archived_object) }
      end
    end
    
    # ===== ARCHIVE ====================================================================================================
    
    attr_reader :archive_object
    
    def archive
      archive_object.archive
    end
    
    def self.class_for_archived_object_type(type)
      case type
      when "PBXProject"
        Project
      when "PBXFileReference"
        FileReference
      when "PBXNativeTarget"
        Target
      when "XCConfigurationList"
        BuildConfigurationList
      when "XCBuildConfiguration"
        BuildConfiguration
      end
    end
    
    def self.map_archived_object(archived_object)
      if klass = class_for_archived_object_type(archived_object['isa'])
        klass.new(archived_object)
      end
    end
    
    def self.object_at_path(archive_path)
      Archive.new(archive_path).rootObject.model_object
    end
    
    # ===== ROOT =======================================================================================================
    
    def root
      self.archive.root_object.model_object
    end
    
  end
  
end