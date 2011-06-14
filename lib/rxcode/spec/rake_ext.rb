#
# Extensions to workaround segfaults in MacRuby and Rake 0.8.7
#

if defined?(Rake::AltSystem)
  
  #
  # The Rake gem aliases Kernel.system and the backtick operator into this module. For some reason, this causes a
  # Segfault. Strangely AltSystem doesn't exist in the MacRuby-provided rake.
  #
  module Rake::AltSystem
  
    def self.system(*args)
      Kernel.system(*args)
    end
  
    def self.`(*args)
      Kernel.method(:`).call(*args)
    end
  
    def self.backticks(*args)
      Kernel.method(:`).call(*args)
    end
  
  end
  
end