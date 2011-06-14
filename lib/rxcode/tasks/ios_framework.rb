if RXCode.being_run_by_xcode?
  
  module RXCode
    module XCode
      
      class CommandLine
        
        def initialize(options = nil)
          if options
            options.each { |attr_name, attr_value| self.send("#{attr_name}=", attr_value) }
          end
          
          yield self if block_given?
        end
        
        # ===== ACTION =================================================================================================
        
        attr_accessor :action
        
        def action_arguments
          if action
            [ action ]
          else
            []
          end
        end
        
        # ===== PROJECT ================================================================================================
        
        def project_name
          ENV['PROJECT_NAME']
        end
        
        def project_file_path
          ENV['PROJECT_FILE_PATH'] || "#{project_name}.xcodeproj"
        end
        
        def project_arguments
          [ '-project', project_file_path ]
        end
        
        # ===== TARGET =================================================================================================
        
        def target
          @target || target_name
        end
        attr_writer :target
        
        def target_name
          ENV['TARGET_NAME']
        end
        
        def target_arguments
          if target
            [ "-target", "'#{target}'" ]
          else
            []
          end
        end
        
        # ===== CONFIGURATION ==========================================================================================
        
        def configuration
          ENV['CONFIGURATION']
        end
        
        def configuration_arguments
          [ '-configuration', configuration]
        end
        
        # ===== SDK ====================================================================================================
        
        attr_accessor :sdk
        
        def sdk_arguments
          if sdk.nil?
            []
          else
            [ '-sdk', sdk ]
          end
        end
        
        # ===== BUILD LOCATION =========================================================================================
        
        def symroot
          ENV['SYMROOT']
        end
        
        # ===== ENVIRONMENT VARIABLES ==================================================================================
        
        def default_environment
          default_env = {}
          default_env['SYMROOT'] = symroot if symroot
          default_env
        end
        
        def environment
          @environment ||= {}
        end
        
        def command_environment
          default_environment.merge(environment)
        end
        
        def command_variables
          environment.collect { |var_name, value| "#{var_name}='#{value}'" }.join(' ')
        end
        
        # ===== COMMAND ================================================================================================
        
        def xcodebuild_binary
          "xcodebuild"
        end
        
        def command_line_arguments
          project_arguments + target_arguments + configuration_arguments + sdk_arguments + action_arguments
        end
        
        def command
          command_args = command_line_arguments.join(' ')
          command_variables = command_environment.collect { |var_name, value| "#{var_name}='#{value}'" }.join(' ')
          
          "#{xcodebuild_binary} #{command_args} #{command_variables}"
        end
        
        def dry_run?
          ENV['DRY_RUN'] =~ /^(1|yes|true)$/i
        end
        
        def run(print_command = false)
          puts(command) if print_command
          system(command) unless dry_run?
        end
        
      end
      
    end
  end
  
  namespace :rxcode do
    
    namespace :ios_framework do
      
      def construct_ios_framework(platform_name, *source_platforms)
        build_dir = ENV['BUILD_DIR']
        configuration = ENV['CONFIGURATION']
        project_name = ENV['PROJECT_NAME']
        product_name = ENV['PRODUCT_NAME']
        static_target = ENV['STATIC_TARGET']
        
        if source_platforms.empty?
          source_platforms = [ platform_name ]
        end
        
        source_library_paths =
          source_platforms.collect do |source_platform_name|
            "\"#{build_dir}/#{configuration}-#{source_platform_name}/lib#{static_target}.a\""
          end
        
        platform_dir          = "#{build_dir}/#{configuration}-#{platform_name}"
        platform_library_path = "#{platform_dir}/#{product_name}"
        framework             = "#{platform_dir}/#{product_name}.framework"

        # Create framework directory structure.
        # rm -rf "${FRAMEWORK}" &&
        # mkdir -p "${UNIVERSAL_LIBRARY_DIR}" &&
        # mkdir -p "${FRAMEWORK}/Versions/A/Headers" &&
        # mkdir -p "${FRAMEWORK}/Versions/A/Resources" &&
        
        FileUtils.rm_rf     framework
        FileUtils.mkdir_p   platform_dir
        FileUtils.mkdir_p   "#{framework}/Versions/A/Headers"
        FileUtils.mkdir_p   "#{framework}/Versions/A/Resources"
        
        # Generate universal binary from desktop, device, and simulator builds.
        # lipo "${SIMULATOR_LIBRARY_PATH}" "${DEVICE_LIBRARY_PATH}" -create -output "${UNIVERSAL_LIBRARY_PATH}" &&
        `lipo #{source_library_paths.join(' ')} -create -output "#{platform_library_path}"`
        
        # Move files to appropriate locations in framework paths.
        # cp "${UNIVERSAL_LIBRARY_PATH}" "${FRAMEWORK}/Versions/A" &&
        # cd "${FRAMEWORK}/Versions" &&
        # ln -s "A" "Current" &&
        #    cd "${FRAMEWORK}" &&
        # ln -s "Versions/Current/Headers" "Headers" &&
        # ln -s "Versions/Current/Resources" "Resources" &&
        # ln -s "Versions/Current/${PRODUCT_NAME}" "${PRODUCT_NAME}"
        
        FileUtils.cp  platform_library_path, "#{framework}/Versions/A"
        Dir.chdir(framework) do
          Dir.chdir("Versions") do
            FileUtils.ln_s  "A", "Current"
          end
          
          FileUtils.ln_s  "Versions/Current/Headers", "Headers"
          FileUtils.ln_s  "Versions/Current/Resources", "Resources"
          FileUtils.ln_s  "Versions/Current/#{product_name}", product_name
        end
        
        # Copy headers from a cocoa framework
        script_input_file_count = ENV['SCRIPT_INPUT_FILE_COUNT'].to_i
        script_input_files = []
        script_input_file_count.times do |i|
          input_file_glob = ENV["SCRIPT_INPUT_FILE_#{i}"]
          
          script_input_files.concat(Dir[ENV["SCRIPT_INPUT_FILE_#{i}"]])
        end
        
        script_input_files.each do |input_file_path|
          if input_file_path =~ /\.h$/
            destination_file_path = File.join("#{framework}/Versions/Current/Headers", File.basename(input_file_path))
            FileUtils.cp input_file_path, destination_file_path
          end
        end
      end
      
      namespace :iphonesimulator do
        
        task :build do
          RXCode::XCode::CommandLine.new(:sdk => 'iphonesimulator',
                                          :target => ENV['STATIC_TARGET'],
                                          :action => 'build').run(true)
          construct_ios_framework('iphonesimulator')
        end
        task :clean do
          RXCode::XCode::CommandLine.new(:sdk => 'iphonesimulator',
                                          :target => ENV['STATIC_TARGET'],
                                          :action => 'clean').run(true)
        end
        
      end
      
      namespace :iphoneos do
        task :build do
          RXCode::XCode::CommandLine.new(:sdk => 'iphoneos',
                                          :target => ENV['STATIC_TARGET'],
                                          :action => 'build').run(true)
          construct_ios_framework('iphoneos')
        end
        task :clean do
          RXCode::XCode::CommandLine.new(:sdk => 'iphoneos',
                                          :target => ENV['STATIC_TARGET'],
                                          :action => 'clean').run(true)
        end
      end
      
      namespace :universal do
        
        task :build => [ "rxcode:ios_framework:iphonesimulator:build", "rxcode:ios_framework:iphoneos:build"] do
          construct_ios_framework('iphoneuniversal', 'iphonesimulator', 'iphoneos')
        end
        
        task :clean => [ "rxcode:ios_framework:iphonesimulator:clean", "rxcode:ios_framework:iphoneos:clean"]
        
      end
      
      desc %{Builds a framework bundle that can be linked to by an iOS project}
      task :build => [ "rxcode:ios_framework:universal:build" ]
      
      desc %{Cleans up after rxcode:ios_framework:build}
      task :clean => [ "rxcode:ios_framework:universal:clean" ]
      
    end
    
  end
  
end