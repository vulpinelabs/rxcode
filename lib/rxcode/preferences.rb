require 'plist'

module RXCode
  
  def self.xcode_preferences
    @preferences ||= Preferences.new
  end
  
  #
  # Provides access to global XCode preferences.
  #
  class Preferences
    
    attr_reader :defaults
    
    def initialize(defaults = nil)
      defaults ||= Plist::parse_xml(`defaults read com.apple.dt.Xcode | plutil -convert xml1 -o - -`)
      
      @defaults = defaults
    end
    
    def derived_data_location
      defaults['IDECustomDerivedDataLocation'] || File.expand_path("~/Library/Developer/Xcode/DerivedData")
    end
    
    def derived_data_location_is_relative_to_workspace?
      !derived_data_location.start_with?('/')
    end
    
  end
  
end