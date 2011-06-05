module RXCode
module Commands
  
  class Unwrap < ::RXCode::Command
    
    # ===== COMMAND LINE OPTIONS =======================================================================================
    
    def self.new_command_option_parser
      Trollop::Parser.new do
        banner <<-TEXT
Unwraps archive files, in particular the project.pbxproj file, and prints their contents to standard out as a ruby hash.

Usage:
  rxcode [global options] unwrap [options] FILENAME...

Options:
        TEXT
        
        opt :raw, "Prints the raw archive structure instead of the object structure"
      end
    end
    
    # ===== OBJECT UNWRAPPING ==========================================================================================
    
    def self.unwrap_object_with_id(objects, archive, object_id)
      if objects.has_key?(object_id)
        
        objects[object_id]
        
      elsif object_hash = archive.object_hashes[object_id]
        
        unwrapped_object = {}
        objects[object_id] = unwrapped_object
        
        object_hash.each do |object_key, object_value|
          unwrapped_object[object_key] = unwrap_object_value(objects, archive, object_value)
        end
        
        unwrapped_object
      end
    end
    
    def self.unwrap_object_value(objects, archive, object_value)
      if object_value.is_a?(String) && archive.object_hashes.has_key?(object_value)
        unwrap_object_with_id(objects, archive, object_value)
      elsif object_value.is_a?(Array) && object_value.all? { |array_member| archive.object_hashes.has_key?(array_member) }
        object_value.map { |array_member| unwrap_object_with_id(objects, archive, array_member) }
      else
        object_value
      end
    end
    
    def unwrap_objects?
      !options[:raw]
    end
    
    # ===== RUN! =======================================================================================================
    
    def run!
      require 'pp'
      
      arguments.each do |filename|
        archive = ::RXCode::Archive.new(filename)
        if unwrap_objects?
          unwrapped_dictionary = self.class.unwrap_object_with_id({}, archive, archive.root_object_archive_id)
          PP.pp(unwrapped_dictionary, output)
        else
          PP.pp(archive.archive_hash, output)
        end
      end
    end
    
  end
  
end
end