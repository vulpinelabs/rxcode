module RXCode
  
  class Project < Model
    
    def initialize(path, options = nil)
      raise "#{path.inspect} is not a valid XCode project path" unless self.class.is_project_at_path?(path)
      
      super nil
      
      @path = path
      
      if options && options[:workspace]
        @workspace = options[:workspace]
      end
    end
    
    # ===== WORKSPACE ==================================================================================================
    
    attr_reader :workspace
    
    # ===== PROJECT DISCOVERY & LOOKUP =================================================================================
    
    XCODE_PROJECT_EXTENSION = '.xcodeproj'.freeze
    
    #
    # Determines if the provided file path is an XCode project
    #
    def self.is_project_at_path?(project_path)
      File.directory?(project_path) && File.extname(project_path) == XCODE_PROJECT_EXTENSION
    end
    
    # ===== PROJECT PATH ===============================================================================================
    
    attr_reader :path
    
    def project_archive_path
      File.join(self.path, 'project.pbxproj')
    end
    
    def archive
      @archive ||=
        begin
          a = Archive.new(project_archive_path) { |archived_object| Model.map_archived_object(archived_object) }
          a.root_object.model_object = self
          a
        end
    end
    
    def archive_object
      archive.root_object
    end
    
    # ===== TARGETS ====================================================================================================
    
    def targets
      archive_object.array_of_model_objects_for_key('targets')
    end
    
    def target_names
      targets.map(&:name)
    end
    
    # ===== BUILD CONFIGURATIONS =======================================================================================
    
    def build_configuration_list
      archive_object.model_object_for_key('buildConfigurationList')
    end
    
  end
  
end