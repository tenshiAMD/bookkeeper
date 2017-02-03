require 'rails/generators'
require 'highline/import'
require 'bundler'
require 'bundler/cli'

module Bookkeeper
  class InstallGenerator < Rails::Generators::Base
    class_option :migrate, type: :boolean, default: true

    def self.source_paths
      paths = superclass.source_paths
      paths << File.expand_path('../templates', "../../#{__FILE__}")
      paths << File.expand_path('../templates', "../#{__FILE__}")
      paths << File.expand_path('../templates', __FILE__)
      paths.flatten
    end

    def prepare_options
      @run_migrations = options[:migrate]
    end

    def install_initializers
      say_status :copying, 'inititalizers'
      template 'config/initializers/bookkeeper.rb', 'config/initializers/bookkeeper.rb'
    end

    def install_migrations
      say_status :copying, 'migrations'
      silence_warnings { rake 'railties:install:migrations' }
    end

    def run_migrations
      if @run_migrations
        say_status :running, 'migrations'
        silence_warnings { rake 'db:migrate' }
      else
        say_status :skipping, "migrations (don't forget to run rake db:migrate)"
      end
    end
  end
end
