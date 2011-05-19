module RXCode
  
  class Workspace
    
    def initialize(workspace_path)
      unless self.class.is_workspace_at_path?(workspace_path)
        raise "#{workspace_path.inspect} is not a valid XCode workspace path" 
      end
      
      @path = workspace_path
    end
    
    # ===== PATH =======================================================================================================
    
    attr_reader :path
    
    def resolve_file_reference(location)
      if location =~ /^(?:container|group):(.*)$/
        File.expand_path("../#{$1}", path)
      else
        location
      end
    end
    
    # ===== PROJECTS ===================================================================================================
    
    def projects
      @projects ||= project_paths.map { |project_path| Project.new(project_path) }
    end
    
    def project_paths
      require 'nokogiri'
      
      if File.exist?(contents_path)
        document = Nokogiri::XML(File.read(contents_path))
        
        document.xpath('/Workspace/FileRef').collect { |element|
          resolve_file_reference(element['location']) if element['location'] =~ /\.xcodeproj$/
        }.compact
        
      else
        []
      end
    end
    
    # ===== CONTENTS ===================================================================================================
    
    def contents_path
      @contents_path ||= File.join(path, 'contents.xcworkspacedata').freeze
    end
    
    # ===== WORKSPACE DISCOVERY ========================================================================================
    
    WORKSPACE_EXTENSION = '.xcworkspace'
    
    def self.is_workspace_at_path?(path)
      File.extname(path) == WORKSPACE_EXTENSION && File.directory?(path)
    end
    
  end
  
end