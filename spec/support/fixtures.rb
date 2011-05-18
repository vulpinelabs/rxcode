module RXCode
  
  module Fixtures
    
    PROJECT_FIXTURE_DIRECTORY = File.expand_path('../../fixtures', __FILE__)
    
    def self.project_named(project_name)
      fixture_path = File.join(PROJECT_FIXTURE_DIRECTORY, project_name, "#{project_name}.xcodeproj")
      if RXCode::Project.is_project_at_path?(fixture_path)
        RXCode::Project.new(fixture_path)
      end
    end
    
  end
  
end

