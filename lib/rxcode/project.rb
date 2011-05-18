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
    
    #
    # Searches the provided path and its ancestors for XCode projects, returning an array of projects it finds.
    # Searching stops at the first ancestor that contains one or more projects. If the path is itself an XCode project,
    # the path is returned without searching.
    #
    def self.find_project_paths_with_path(path)
      if self.is_project_at_path?(path)
        [ path ]
      else
        
        dir_path =
          if File.directory?(path)
            path
          else
            File.dirname(path)
          end
        
        project_paths = Dir[File.join(dir_path, "*.xcodeproj")].select { |path| self.is_project_at_path?(path) }
        if project_paths.empty? && !dir_path.empty? && dir_path != "/"
          project_paths = find_project_paths_with_path(File.dirname(dir_path))
        end
        
        project_paths
      end
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