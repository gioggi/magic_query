# frozen_string_literal: true

require_relative 'base_loader'

module MagicQuery
  module Schema
    class DatabaseLoader < BaseLoader
      def initialize(config, database_url)
        super(config)
        @database_url = database_url
      end

      def self.can_load?(database_url)
        !database_url.nil? && !database_url.empty?
      end

      protected

      def load_schema
        # For generic SQL, we'll try to extract schema using a simple approach
        # In a real implementation, you might want to use database-specific adapters
        raise Error, 'Automatic schema extraction requires database-specific implementation'
      end
    end
  end
end
