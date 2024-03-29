module Bookkeeper
  class Migrations
    attr_reader :config, :engine_name

    # Takes the engine config block and engine name
    def initialize(config, engine_name)
      @config = config
      @engine_name = engine_name
    end

    # Puts warning when any engine migration is not present on the Rails app
    # db/migrate dir
    #
    # First split:
    #
    #   ["20131128203548", "update_name_fields_on_spree_credit_cards.spree.rb"]
    #
    # Second split should give the engine_name of the migration
    #
    #   ["update_name_fields_on_spree_credit_cards", "spree.rb"]
    #
    # Shouldn't run on test mode because migrations inside engine don't have
    # engine name on the file name
    def check
      return unless File.directory?(app_dir)
      engine_in_app = app_migrations.map do |file_name|
        name, engine = file_name.split('.', 2)
        next unless match_engine?(engine)
        name
      end.compact

      missing_migrations = engine_migrations.sort - engine_in_app.sort
      return if missing_migrations.empty?
      logger.warn "[#{engine_name.titleize} WARNING] Missing migrations."
      missing_migrations.each do |migration|
        logger.warn "[#{engine_name.titleize} WARNING] #{migration} from #{engine_name.titleize} is missing."
      end
      logger.warn "[#{engine_name.titleize} WARNING] Run `bundle exec rake " \
          "railties:install:migrations` to get them.\n\n"
      true
    end

    private

    def app_dir
      "#{Rails.root}/db/migrate"
    end

    def app_migrations
      Dir.entries(app_dir).map do |file_name|
        next if ['.', '..'].include? file_name
        name = file_name.split('_', 2).last
        name.empty? ? next : name
      end.compact! || []
    end

    def engine_dir
      "#{config.root}/db/migrate"
    end

    def engine_migrations
      Dir.entries(engine_dir).map do |file_name|
        name = file_name.split('_', 2).last.split('.', 2).first
        name.empty? ? next : name
      end.compact! || []
    end

    def match_engine?(engine)
      engine == "#{engine_name}.rb"
    end
  end
end
