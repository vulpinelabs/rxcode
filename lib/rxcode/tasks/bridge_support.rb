if RXCode.being_run_by_xcode? && RXCode.building_cocoa_framework?
  bridge_support_folder_path = File.join(ENV['BUILT_PRODUCTS_DIR'],
                                         ENV['UNLOCALIZED_RESOURCES_FOLDER_PATH'],
                                         'BridgeSupport')

  framework_location = File.join(ENV['BUILT_PRODUCTS_DIR'], ENV['FULL_PRODUCT_NAME'])
  bridge_support_file_location = File.join(bridge_support_folder_path, "#{ENV['PRODUCT_NAME']}.bridgesupport")

  directory bridge_support_folder_path

  file bridge_support_file_location => bridge_support_folder_path do |t|
  
    puts "Building #{bridge_support_file_location.inspect}"
    result = `gen_bridge_metadata --64-bit -f "#{framework_location}" -o "#{bridge_support_file_location}"`
    unless $?.success?
      puts result
      exit 1
    end
  
  end
  
  public_headers_location = File.join(ENV['BUILT_PRODUCTS_DIR'], ENV['PUBLIC_HEADERS_FOLDER_PATH'])
  FileList[File.join(public_headers_location, '**', '*.h')].each do |header_file|
    file bridge_support_file_location => header_file
  end
  
  private_headers_location = File.join(ENV['BUILT_PRODUCTS_DIR'], ENV['PRIVATE_HEADERS_FOLDER_PATH'])
  FileList[File.join(private_headers_location, '**', '*.h')].each do |header_file|
    file bridge_support_file_location => header_file
  end
  
  namespace :rxcode do
    
    desc %{Generates the BridgeSupport file for a Cocoa framework.}
    task :generate_bridgesupport_file => bridge_support_file_location
  
  end
  
end