# frozen_string_literal: true

module MagicQuery
  module Query
    class Parser
      def self.extract_sql(response_text)
        new(response_text).extract
      end

      def initialize(response_text)
        @response_text = response_text.to_s.strip
      end

      def extract
        # Try to extract SQL from markdown code blocks first
        sql = extract_from_markdown || extract_direct_sql || @response_text

        # Clean up the SQL
        clean_sql(sql)
      end

      private

      def extract_from_markdown
        # Match SQL in markdown code blocks
        match = @response_text.match(/```(?:sql)?\s*\n?(.*?)```/m)
        match ? match[1].strip : nil
      end

      def extract_direct_sql
        # Try to find SELECT statement
        match = @response_text.match(/(SELECT\s+.*?(?:;|$))/mi)
        match ? match[1].strip : nil
      end

      def clean_sql(sql)
        # Remove trailing semicolons and extra whitespace
        sql = sql.strip
        sql = sql.chomp(';') if sql.end_with?(';')
        sql.strip
      end
    end
  end
end
