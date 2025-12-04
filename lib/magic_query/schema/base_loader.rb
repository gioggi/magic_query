# frozen_string_literal: true

require_relative 'validator'

module MagicQuery
  module Schema
    class BaseLoader
      def initialize(config)
        @config = config
      end

      def load
        schema = load_schema
        validate_schema(schema)
        schema
      end

      protected

      def load_schema
        raise NotImplementedError, 'Subclasses must implement load_schema'
      end

      def validate_schema(schema)
        errors = Validator.validate(schema)
        raise Error, "Invalid schema: #{errors.join(', ')}" unless errors.empty?
      end
    end
  end
end
