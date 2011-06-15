require 'rxcode/spec/rake_task'

desc %{Run specs using MacRuby and RSpec}
if defined?(MACRUBY_VERSION)
  
  if defined?(RXCode::Spec::RakeTask)
    
    RXCode::Spec::RakeTask.new("rxcode:spec")
    
  else
    
    task 'rxcode:spec' do
      raise "RSpec could not be found. Please install it to run specs"
    end
    
  end
  
else
  
  task 'rxcode:spec' do
    raise "Testing with RSpec requires MacRuby."
  end
  
end