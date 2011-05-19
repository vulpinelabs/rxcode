module RXCode
  
  class Project
    
    def initialize(path)
      raise "#{path.inspect} is not a valid XCode project path" unless self.class.is_project_at_path?(path)
      
      @path = path
    end
    
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
    
    def unwrapped_project_data
      @unwrapped_project_data ||= Unwrapper.unwrap_object_at_path(project_archive_path)
    end
    
    # ===== TARGETS ====================================================================================================
    
    def target_names
      unwrapped_project_data['targets'].map { |target_data| target_data['name'] }
    end
    
  end
  
end