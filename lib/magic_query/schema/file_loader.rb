# frozen_string_literal: true

require 'yaml'
require_relative 'base_loader'
require_relative 'parser'

module MagicQuery
  module Schema
    class FileLoader < BaseLoader
      def initialize(config, path)
        super(config)
        @path = path
      end

      def self.can_load?(path)
        path && File.exist?(path)
      end

      protected

      def load_schema
        content = File.read(@path)
        if @path.end_with?('.yml', '.yaml')
          load_yaml_schema(content)
        else
          Parser.parse(content)
        end
      end

      private

      def load_yaml_schema(content)
        yaml_data = YAML.safe_load(content)
        schema = {}
        yaml_data.each do |table_name, table_info|
          schema[table_name.to_s] = {
            columns: table_info['columns'] || [],
            constraints: table_info['constraints'] || []
          }
        end
        schema
      end
    end
  end
end
