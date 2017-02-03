RSpec.configure do |config|
  # Clean out the database state before the tests run
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation, except: %w(ar_internal_metadata))
    DatabaseCleaner.strategy = :transaction
  end

  # Wrap all db isolated tests in a transaction
  config.around(db: :isolate) do |example|
    DatabaseCleaner.cleaning(&example)
  end

  config.around do |example|
    Timeout.timeout(30, &example)
  end
end
