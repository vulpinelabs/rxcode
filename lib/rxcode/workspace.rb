module RXCode
  
  class Workspace
    
    def initialize(workspace_path, env=nil)
      unless self.class.is_workspace_at_path?(workspace_path)
        raise "#{workspace_path.inspect} is not a valid XCode workspace path" 
      end
      
      @path = workspace_path
      @env = env
    end
    
    # ===== WORKSPACE DISCOVERY ========================================================================================
    
    WORKSPACE_EXTENSION = '.xcworkspace'
    
    def self.is_workspace_at_path?(path)
      File.extname(path) == WORKSPACE_EXTENSION && File.directory?(path)
    end
    
    # ===== ENVIRONMENT ================================================================================================
    
    attr_accessor :env
    def env
      @env || RXCode.env
    end
    
    # ===== PATH =======================================================================================================
    
    attr_reader :path
    
    def root
      if project_dependent?
        File.expand_path('../..', path)
      else
        File.dirname(path)
      end
    end
    
    def resolve_file_reference(location)
      if location =~ /^(?:container|group):(.*)$/
        File.expand_path("../#{$1}", path)
      else
        location
      end
    end
    
    def name
      File.basename(path, '.xcworkspace')
    end
    
    # ===== PROJECTS ===================================================================================================
    
    def project_dependent?
      name == 'project' && RXCode::Project.is_project_at_path?(File.dirname(path))
    end
    
    def enclosing_product_path
      File.dirname(path) if project_dependent?
    end
    
    def project_independent?
      !project_dependent?
    end
    
    def projects
      @projects ||= project_paths.map { |project_path| Project.new(project_path, :workspace => self) }
    end
    
    def project_paths
      require 'nokogiri'
      
      if project_dependent?
        
        [ File.dirname(path) ]
        
      elsif File.exist?(contents_path)
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
    
    # ===== BUILD LOCATION =============================================================================================
    
    def derived_data_location
      prefs = (env ? env.preferences : RXCode.preferences)
      
      if prefs.derived_data_location_is_relative_to_workspace?
        File.expand_path(prefs.derived_data_location, self.root)
      else
        prefs.derived_data_location
      end
    end
    
    def build_location
      Dir[File.join(derived_data_location, '*/info.plist')].each do |info_plist_path|
        build_location_data = Plist::parse_xml(info_plist_path)
        workspace_path = build_location_data['WorkspacePath']
        
        if workspace_path == self.path || (project_dependent? && workspace_path == enclosing_product_path)
          return File.dirname(info_plist_path)
        end
      end
      
      nil
    end
    
    def built_products_dir
      if build_root = build_location
        File.join(build_root, "Build/Products")
      end
    end
    
  end
  
end