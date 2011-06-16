module RXCode
  
  def self.framework(framework_name)
    if workspace_path = RXCode::Workspace.path_of_workspace_from_path(Dir.pwd)
      
      workspace = RXCode::Workspace.new(workspace_path)
      
      framework_path = File.join(workspace.built_products_dir, 'Debug', "#{framework_name}.framework")
      ::Kernel.framework(framework_path)
      
    else
      
      raise "Unable to determine current XCode workspace."
      
    end
  end
  
end