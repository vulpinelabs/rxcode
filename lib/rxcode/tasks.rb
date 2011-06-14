require 'rxcode'

module RXCode
  
  def self.being_run_by_xcode?
    ENV['XCODE_VERSION_ACTUAL'] != nil
  end
  
  def self.building_cocoa_framework?
    ENV['PACKAGE_TYPE'] == 'com.apple.package-type.wrapper.framework'
  end
  
  def self.xcode_action
    ENV['ACTION']
  end
  
end

require 'rxcode/tasks/bridge_support'
require 'rxcode/tasks/ios_framework'

if defined?(MACRUBY_VERSION)
  require 'rxcode/tasks/spec'
end