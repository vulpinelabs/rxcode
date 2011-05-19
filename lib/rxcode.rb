module RXCode
  
  VERSION = File.read(File.expand_path('../../VERSION', __FILE__)).strip
  
end

require 'rxcode/unwrapper'
require 'rxcode/preferences'
require 'rxcode/project'