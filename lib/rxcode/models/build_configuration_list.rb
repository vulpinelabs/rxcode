module RXCode
  
  class BuildConfigurationList < Model
    
    def default_configuration_name
      archive_object['defaultConfigurationName']
    end
    
    def build_configurations
      archive_object.array_of_model_objects_for_key('buildConfigurations')
    end
    
  end
  
end