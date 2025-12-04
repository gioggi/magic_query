# frozen_string_literal: true

module MagicQuery
  module Schema
    class Parser
      def self.parse(sql_schema)
        new(sql_schema).parse
      end

      def initialize(sql_schema)
        @sql_schema = sql_schema.to_s
      end

      def parse
        tables = {}
        current_table = nil

        @sql_schema.lines.each do |line|
          line = line.strip
          next if skip_line?(line)

          current_table = process_line(line, tables, current_table)
        end

        tables
      end

      def skip_line?(line)
        line.empty? || line.start_with?('--')
      end

      def process_line(line, tables, current_table)
        return handle_create_table(line, tables) if create_table?(line)
        return handle_column(line, tables, current_table) if current_table && column_definition?(line)
        return handle_constraint(line, tables, current_table) if current_table && constraint?(line)
        return nil if end_of_table?(line)

        current_table
      end

      def handle_create_table(line, tables)
        extract_table_name(line).tap do |table_name|
          tables[table_name] = { columns: [], constraints: [] }
        end
      end

      def handle_column(line, tables, current_table)
        add_column(line, tables, current_table)
        current_table
      end

      def handle_constraint(line, tables, current_table)
        add_constraint(line, tables, current_table)
        current_table
      end

      def create_table?(line)
        line.match?(/CREATE\s+TABLE/i)
      end

      def column_definition?(line)
        line.match?(/^\w+/)
      end

      def constraint?(line)
        line.match?(/(PRIMARY KEY|FOREIGN KEY|UNIQUE|INDEX)/i)
      end

      def end_of_table?(line)
        line.match?(/\);?$/)
      end

      def add_column(line, tables, current_table)
        column_info = parse_column(line)
        tables[current_table][:columns] << column_info if column_info
      end

      def add_constraint(line, tables, current_table)
        tables[current_table][:constraints] << line
      end

      private

      def extract_table_name(line)
        match = line.match(/CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?(?:`|")?(\w+)(?:`|")?/i)
        match ? match[1] : nil
      end

      def parse_column(line)
        # Simple column parser - extracts name and type
        match = line.match(/^(\w+)\s+(\w+(?:\([^)]+\))?)/i)
        return nil unless match

        {
          name: match[1],
          type: match[2],
          definition: line
        }
      end
    end
  end
end
