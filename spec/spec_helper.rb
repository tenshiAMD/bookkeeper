require 'coveralls'
Coveralls.wear!

ENV['RAILS_ENV'] ||= 'test'

begin
  require File.expand_path('../dummy/config/environment', __FILE__)
rescue LoadError
  puts 'Could not load dummy application. Please ensure you have run `bundle exec rake test_app`'
end

require 'rspec/rails'
require 'database_cleaner'
require 'factory_girl'
require 'ffaker'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

require 'bookkeeper/testing_support/factories'

RSpec.configure do |config|
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, comment the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # # Clean out the database state before the tests run
  # config.before(:suite) do
  #   DatabaseCleaner.clean_with(:truncation)
  #   DatabaseCleaner.strategy = :transaction
  # end
  #
  # # Wrap all db isolated tests in a transaction
  # config.around(db: :isolate) do |example|
  #   DatabaseCleaner.cleaning(&example)
  # end
  #
  # config.around do |example|
  #   Timeout.timeout(30, &example)
  # end
end
