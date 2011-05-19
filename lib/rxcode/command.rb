module RXCode
  
  class Command
    
    #
    # Initializes the command with a set of +options+ and/or +arguments+. The formal way to initialize a command looks
    # like this, with options followed by arguments:
    #
    #    Command.new({ :option => 'value' }, [ 'first arg', 'second arg' ])
    #
    # This is the way it's done using parsed command-line arguments. However, this isn't as intuitive when creating
    # commands programmatically, so the more rubyish constructor signature is also supported:
    #
    #    Command.new('first arg', 'second arg', :option => 'value')
    #    Command.new('first arg', 'second arg')
    #
    def initialize(*args)
      if args.first.is_a?(Hash)
        @options = args.shift
        @arguments = args.shift
      else
        if args.last.is_a?(Hash)
          @options = args.pop
        else
          @options = {}
        end
        
        @arguments = args
      end
      
      yield self if block_given?
    end
    
    # ===== STREAMS ====================================================================================================
    
    attr_accessor :output
    def output
      @output || $>
    end
    
    attr_accessor :err
    def err
      @err || $stderr
    end
    
    attr_accessor :input
    def input
      @input || $<
    end
    
    # ===== OPTIONS ====================================================================================================
    
    attr_reader :options
    
    # ===== ARGUMENTS ==================================================================================================
    
    attr_reader :arguments
    
    # ===== COMMAND REGISTRATION =======================================================================================
    # Commands are automatically registered when they subclass Command.
    
    def self.inherited(subclass)
      self.commands[subclass.display_name] = subclass
    end
    
    def self.commands
      @commands ||= {}
    end
    
    def self.command_names
      self.commands.keys
    end
    
    def self.command_class_for_name(command_name)
      self.commands[command_name]
    end
    
    def self.display_name
      self.name.split('::').last.
        gsub(/([A-Z]+)/) { |uppercase| '_' + uppercase.downcase }.
        gsub(/^_/, '').
        gsub(/[^a-z]_/) { |str| str.gsub(/_$/, '') }
    end
    
    # ===== COMMAND RUNNING ============================================================================================
    
    def run!
      if self.class == Command
        raise "#{self.class.name} is an abstract class."
      else
        raise "#{Command.name}#run! is abstract and should be overridden"
      end
    end
    
    def self.run!(args = ARGV)
      require 'trollop'
      
      global_options = {}
      command_name = nil
      command_arguments = []
      
      parser = self.new_global_option_parser
      Trollop::with_standard_exception_handling parser do
        global_options = parser.parse(args)
        command_arguments = parser.leftovers
        command_name = command_arguments.shift
        
        if command_name.nil?
          
          if (options.keys - [:version, :help]).empty?
            raise Trollop::HelpNeeded
          else
            parser.die("No command given", nil)
          end
          
        elsif !RXCode::Command.command_names.include?(command_name)
          
          parser.die("Unknown command (#{command_name.inspect})", nil)
        
        end
        
      end
      
      run_command(command_name, command_arguments, global_options)
    end
    
    def self.run_command(command_name, command_args = [], global_options = {})
      if command_class = self.command_class_for_name(command_name)
        parser = command_class.new_command_option_parser
        
        Trollop::with_standard_exception_handling parser do
          
          command_options = parser.parse(command_args)
          command_arguments = parser.leftovers
          
          command = command_class.new(command_options, command_arguments)
          command.run!
        end
        
      else
        raise "Invalid Command: #{command_name.inspect}"
      end
      
    end
    
    # ----- COMMAND LINE PARSER ----------------------------------------------------------------------------------------
    
    def self.new_global_option_parser
      
      Trollop::Parser.new do
        version "rxcode #{RXCode::VERSION}"
        banner "A utility for manipulating XCode projects."
        stop_on_unknown
      end
      
    end
    
    def self.new_command_option_parser
      Trollop::Parser.new
    end
    
  end
  
end