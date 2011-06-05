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
    
    def project
      self.archive.root_object.model_object
    end
    
    # ===== PATH LOOKUP ================================================================================================
    
    def source_tree_path
      case source_tree
      when "BUILT_PRODUCTS_DIR"
        self.project.workspace.built_products_dir if (self.project && self.project.workspace)
      end
    end
    
    def file_system_path
      base_dir = self.source_tree_path
      configuration = self.project.workspace.env.configuration
      
      File.join(base_dir, configuration, path)
    end
    
  end
  
end