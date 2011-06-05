module RXCode
  
  class Project < Model
    
    def initialize(path, options = nil)
      super nil
      
      raise "#{path.inspect} is not a valid XCode project path" unless self.class.is_project_at_path?(path)
      
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
      @archive ||= Archive.archive_at_path(project_archive_path)
    end
    
    def archive_object
      archive.root_object
    end
    
    # ===== TARGETS ====================================================================================================
    
    def targets
      @targets ||= archive_object.array_of_objects_for_key('targets').map { |target_data| Target.new(target_data) }
    end
    
    def target_names
      targets.map(&:name)
    end
    
  end
  
end