require "spec_helper"
require 'tmpdir'

describe RXCode::Commands::Init do
  
  before(:each) do
    @project_directory = Dir.mktmpdir('rxcode_init')
    @project_package = File.join(@project_directory, 'MyProject.xcodeproj')
    
    RXCode::Fixtures.init_empty_project(@project_package)
  end
  
  after(:each) do
    FileUtils.rm_rf(@project_directory)
  end
  
  describe "#run!" do
  
    before(:each) do
      @command = RXCode::Commands::Init.new(@project_directory)
      @command.run!
    end
    
    it "should create a Gemfile" do
      File.file?(File.join(@project_directory, "Gemfile")).should be_true
    end
    
    it "should create a Rakefile" do
      File.file?(File.join(@project_directory, "Rakefile")).should be_true
    end
    
    it "should create a spec helper" do
      File.file?(File.join(@project_directory, "spec/spec_helper.rb")).should be_true
    end
    
    it "should create a support directory" do
      File.directory?(File.join(@project_directory, "spec/support")).should be_true
    end
  
  end
  
end