# frozen_string_literal: true

module MagicQuery
  module Query
    class Validator
      def self.validate(sql)
        new(sql).validate
      end

      def self.valid?(sql)
        new(sql).valid?
      end

      def initialize(sql)
        @sql = sql.to_s.strip
      end

      def validate
        errors = []

        if @sql.empty?
          errors << 'SQL query is empty'
          return errors
        end

        errors << 'Query must start with SELECT' unless @sql.match?(/^\s*SELECT/i)
        errors.concat(check_dangerous_keywords)

        errors
      end

      def check_dangerous_keywords
        errors = []
        dangerous_keywords = %w[DROP DELETE UPDATE INSERT ALTER CREATE TRUNCATE]
        dangerous_keywords.each do |keyword|
          errors << "Query contains dangerous keyword: #{keyword}" if @sql.match?(/\b#{keyword}\b/i)
        end
        errors
      end

      def valid?
        validate.empty?
      end
    end
  end
end
