# frozen_string_literal: true

require 'yaml'

module MagicQuery
  module Config
    class RulesLoader
      def self.load(path)
        new(path).load
      end

      def initialize(path)
        @path = path
      end

      def load
        return {} unless @path && File.exist?(@path)

        yaml_data = YAML.safe_load_file(@path) || {}
        normalize_rules(yaml_data)
      end

      private

      def normalize_rules(yaml_data)
        {
          tables: deep_symbolize_keys(yaml_data['tables'] || {}),
          columns: deep_symbolize_keys(yaml_data['columns'] || {}),
          relationships: yaml_data['relationships'] || [],
          naming_conventions: deep_symbolize_keys(yaml_data['naming_conventions'] || {}),
          business_rules: yaml_data['business_rules'] || []
        }
      end

      def deep_symbolize_keys(obj)
        case obj
        when Hash
          obj.each_with_object({}) do |(key, value), result|
            result[key.to_sym] = deep_symbolize_keys(value)
          end
        when Array
          obj.map { |item| deep_symbolize_keys(item) }
        else
          obj
        end
      end
    end
  end
end
