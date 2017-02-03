require 'generators/bookkeeper/install/install_generator'
require 'generators/bookkeeper/dummy/dummy_generator'

desc 'Generates a dummy app for testing'
namespace :common do
  task :test_app do |_t, _args|
    require 'bookkeeper'

    ENV['RAILS_ENV'] = 'test'

    Bookkeeper::DummyGenerator.start %w(--quiet)
    Bookkeeper::InstallGenerator.start %w(--migrate=false --quiet)

    puts 'Setting up dummy database...'
    system("bundle exec rake db:drop db:create db:migrate > #{File::NULL}")
  end
end
