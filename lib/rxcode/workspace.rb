module RXCode
  
  class Workspace
    
    def initialize(workspace_path)
      unless self.class.is_workspace_at_path?(workspace_path)
        raise "#{workspace_path.inspect} is not a valid XCode workspace path" 
      end
      
      @path = workspace_path
    end
    
    # ===== WORKSPACE DISCOVERY ========================================================================================
    
    WORKSPACE_EXTENSION = '.xcworkspace'
    
    def self.is_workspace_at_path?(path)
      File.extname(path) == WORKSPACE_EXTENSION && File.directory?(path)
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
      derived_data_style = value_for_setting('IDEWorkspaceUserSettings_DerivedDataLocationStyle')
      custom_derived_data_location = value_for_setting('IDEWorkspaceUserSettings_DerivedDataCustomLocation')
      
      if derived_data_style == 2 # 2 is the code for 'Workspace-relative path'
        File.expand_path(custom_derived_data_location, self.root)
      else
        
        prefs = RXCode.xcode_preferences
        if prefs.derived_data_location_is_relative_to_workspace?
          File.expand_path(prefs.derived_data_location, self.root)
        else
          prefs.derived_data_location
        end
        
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
    
    # ===== SETTINGS ===================================================================================================
    
    def shared_data_directory
      File.join(self.path, "xcshareddata")
    end
    
    def shared_settings_file
      File.join(shared_data_directory, "WorkspaceSettings.xcsettings")
    end
    
    def shared_settings
      settings_file = shared_settings_file
      if File.file?(settings_file)
        Plist::parse_xml(settings_file)
      else
        {}
      end
    end
    
    def user_data_directory_for_user(user_name)
      File.join(path, "xcuserdata", "#{user_name}.xcuserdatad")
    end
    
    def settings_file_for_user(user_name)
      File.join(user_data_directory_for_user(user_name), "WorkspaceSettings.xcsettings")
    end
    
    def settings_for_user(user_name)
      settings_file = settings_file_for_user(user_name)
      if File.file?(settings_file)
        Plist::parse_xml(settings_file)
      else
        {}
      end
    end
    
    def user_settings
      settings_for_user(ENV['USER'])
    end
    
    def value_for_setting(setting_name)
      user_settings[setting_name] || shared_settings[setting_name]
    end
    
    # ===== WORKSPACE DISCOVERY ========================================================================================
    
    def self.path_of_workspace_from_path(provided_path)
      preferred_workspace_name = File.basename(provided_path)
      
      workspace_paths = Dir[File.join(provided_path, '*.xcworkspace')]
      preferred_workspace_path = File.join(provided_path, "#{preferred_workspace_name}.xcworkspace")
      
      if workspace_paths.include?(preferred_workspace_path)
        
        preferred_workspace_path
        
      elsif workspace_paths.length == 1
        
        workspace_paths.first
        
      else
        project_paths = Dir[File.join(provided_path, '*.xcodeproj')]
        preferred_project_path = File.join(provided_path, "#{preferred_workspace_name}.xcodeproj")
        
        project_path =
          if project_paths.include?(preferred_project_path)
            preferred_project_path
          elsif project_paths.length == 1
            project_paths.first
          end
        
        if project_path
          project_workspace_path = File.join(project_path, 'project.xcworkspace')
          if RXCode::Workspace.is_workspace_at_path?(project_workspace_path)
            project_workspace_path
          end
        end
        
      end
    end
    
  end
  
end