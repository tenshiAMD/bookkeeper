require 'rake'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new
task default: :spec

require 'bookkeeper/testing_support/common_rake'

desc 'Generates a dummy app for testing'
namespace :bookkeeper do
  task :test_app do
    ENV['LIB_NAME'] = 'bookkeeper'

    Rake::Task['common:test_app'].invoke
  end
end
