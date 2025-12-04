# frozen_string_literal: true

require_relative 'base_loader'
require_relative 'file_loader'
require_relative 'rails_schema_loader'
require_relative 'database_loader'

module MagicQuery
  module Schema
    class Loader
      def self.load(config)
        new(config).load
      end

      def initialize(config)
        @config = config
      end

      def load
        loader = find_loader
        loader.load
      end

      private

      def find_loader
        # Priority order:
        # 1. File loader (if schema_path is configured and exists)
        # 2. Rails schema loader (if Rails is available and schema.rb exists)
        # 3. Database loader (if database_url is configured)
        # 4. Raise error if none available

        return FileLoader.new(@config, @config.schema_path) if FileLoader.can_load?(@config.schema_path)

        return RailsSchemaLoader.new(@config) if RailsSchemaLoader.can_load?

        return DatabaseLoader.new(@config, @config.database_url) if DatabaseLoader.can_load?(@config.database_url)

        raise Error, 'Either schema_path, Rails environment, or database_url must be configured'
      end
    end
  end
end
