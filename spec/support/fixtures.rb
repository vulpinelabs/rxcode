module RXCode
  
  module Fixtures
    
    # ===== PROJECTS ===================================================================================================
    
    PROJECT_FIXTURE_DIRECTORY = File.expand_path('../../fixtures/projects', __FILE__)
    
    def self.path_of_project(project_name)
      File.join(PROJECT_FIXTURE_DIRECTORY, project_name, "#{project_name}.xcodeproj")
    end
    
    def self.project_named(project_name)
      fixture_path = path_of_project(project_name)
      if RXCode::Project.is_project_at_path?(fixture_path)
        RXCode::Project.new(fixture_path)
      end
    end
    
  end
  
end

