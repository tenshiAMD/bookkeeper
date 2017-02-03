require 'rails/all'

module Bookkeeper
  class Engine < Rails::Engine
    isolate_namespace Bookkeeper
    engine_name 'bookkeeper'

    initializer 'bookkeeper.checking_migrations' do
      Migrations.new(config, engine_name).check
    end
  end
end
