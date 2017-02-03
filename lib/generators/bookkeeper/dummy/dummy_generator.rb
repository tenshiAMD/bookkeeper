require 'rails/generators/rails/app/app_generator'
require 'active_support/core_ext/hash'
require 'bookkeeper/version'

module Bookkeeper
  class DummyGenerator < Rails::Generators::Base
    desc 'Creates blank Rails application, installs Bookkeeper'

    class_option :lib_name, default: 'bookkeeper'
    class_option :database, default: ''

    def self.source_paths
      paths = superclass.source_paths
      paths << File.expand_path('../templates', __FILE__)
      paths.flatten
    end

    def clean_up
      remove_directory_if_exists(dummy_path)
    end

    PASSTHROUGH_OPTIONS = [
      :skip_active_record, :skip_javascript, :database, :javascript, :quiet, :pretend, :force, :skip
    ].freeze

    def generate_test_dummy
      # calling slice on a Thor::CoreExtensions::HashWithIndifferentAccess
      # object has been known to return nil
      opts = {}.merge(options).slice(*PASSTHROUGH_OPTIONS)
      opts[:database] = 'sqlite3' if opts[:database].blank?
      opts[:force] = true
      opts[:skip_bundle] = true
      opts[:old_style_hash] = true

      puts 'Generating dummy Rails application...'
      invoke Rails::Generators::AppGenerator,
             [File.expand_path(dummy_path, destination_root)], opts
    end

    def test_dummy_config
      @lib_name = options[:lib_name]
      @database = options[:database]

      template 'rails/database.yml', "#{dummy_path}/config/database.yml", force: true
      # template 'rails/boot.rb', "#{dummy_path}/config/boot.rb", force: true
      # template 'rails/application.rb', "#{dummy_path}/config/application.rb", force: true
      template 'rails/test.rb', "#{dummy_path}/config/environments/test.rb", force: true
    end

    def test_dummy_inject_extension_requirements
      return unless DummyGeneratorHelper.inject_extension_requirements
      inside dummy_path do
        inject_require_for('bookkeeper')
      end
    end

    def test_dummy_clean
      files = %w(.gitignore doc Gemfile lib/tasks app/assets/images/rails.png vendor spec README.md test
                 app/assets/javascripts/application.js public/index.html public/robots.txt)
      inside dummy_path do
        files.each do |file|
          remove_file file
        end
      end
    end

    attr_reader :lib_name
    attr_reader :database

    protected

    def inject_require_for(requirement)
      inject_into_file 'config/application.rb', %(
begin
  require '#{requirement}'
rescue LoadError
  # #{requirement} is not available.
end
      ), before: /require '#{@lib_name}'/, verbose: true
    end

    def dummy_path
      ENV['DUMMY_PATH'] || 'spec/dummy'
    end

    def module_name
      'Dummy'
    end

    def application_definition
      @application_definition ||= begin

        dummy_application_path = File.expand_path("#{dummy_path}/config/application.rb", destination_root)
        unless options[:pretend] || !File.exist?(dummy_application_path)
          contents = File.read(dummy_application_path)
          contents[(contents.index("module #{module_name}"))..-1]
        end
      end
    end
    alias store_application_definition! application_definition

    def camelized
      @camelized ||= name.gsub(/\W/, '_').squeeze('_').camelize
    end

    def remove_directory_if_exists(path)
      remove_dir(path) if File.directory?(path)
    end

    def gemfile_path
      return '../../../../../Gemfile' if ['bookkeeper'].include?(lib_name)
      '../../../../Gemfile'
    end
  end
end

module Bookkeeper
  module DummyGeneratorHelper
    mattr_accessor :inject_extension_requirements
    self.inject_extension_requirements = false
  end
end
