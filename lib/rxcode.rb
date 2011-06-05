module RXCode
  
  VERSION = File.read(File.expand_path('../../VERSION', __FILE__)).strip
  
end

require 'rxcode/models/archive'
require 'rxcode/models/archived_object'

require 'rxcode/environment'
require 'rxcode/preferences'

require 'rxcode/workspace'

require 'rxcode/models/model'
require 'rxcode/models/project'
require 'rxcode/models/target'
require 'rxcode/models/file_reference'
require 'rxcode/models/build_configuration'
require 'rxcode/models/build_configuration_list'