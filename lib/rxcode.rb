require 'fileutils'

module RXCode
  
  VERSION = File.read(File.expand_path('../../VERSION', __FILE__)).strip
  
end

require 'rxcode/environment'
require 'rxcode/preferences'

require 'rxcode/workspace'
require 'rxcode/models'

if defined?(MACRUBY_VERSION)
  require 'rxcode/macruby'
end