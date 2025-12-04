# frozen_string_literal: true

module MagicQuery
  module Schema
    class Validator
      def self.validate(schema)
        new(schema).validate
      end

      def initialize(schema)
        @schema = schema
      end

      def validate
        errors = []

        unless @schema.is_a?(Hash)
          errors << 'Schema must be a Hash'
          return errors
        end

        @schema.each do |table_name, table_info|
          errors.concat(validate_table(table_name, table_info))
        end

        errors
      end

      def validate_table(table_name, table_info)
        errors = []
        unless table_info.is_a?(Hash)
          errors << "Table #{table_name}: must be a Hash"
          return errors
        end

        errors << "Table #{table_name}: columns must be an Array" unless table_info[:columns].is_a?(Array)
        errors
      end

      def valid?
        validate.empty?
      end
    end
  end
end
