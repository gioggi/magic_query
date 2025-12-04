# frozen_string_literal: true

require_relative 'base_loader'

module MagicQuery
  module Schema
    class RailsSchemaLoader < BaseLoader
      def self.can_load?
        return false unless defined?(Rails)

        schema_path = Rails.root.join('db', 'schema.rb')
        File.exist?(schema_path)
      rescue StandardError
        false
      end

      protected

      def load_schema
        schema_path = Rails.root.join('db', 'schema.rb')
        raise Error, "Rails schema file not found at #{schema_path}" unless File.exist?(schema_path)

        content = File.read(schema_path)
        parse_rails_schema(content)
      end

      private

      def parse_rails_schema(content)
        schema = {}
        state = { current_table: nil, table_columns: [], table_constraints: [] }

        content.lines.each do |line|
          line = line.strip
          next if skip_schema_line?(line)

          process_schema_line(line, schema, state)
        end

        save_current_table(schema, state) if state[:current_table] && !state[:table_columns].empty?
        filter_system_tables(schema)
      end

      def skip_schema_line?(line)
        line.empty? || line.start_with?('#') || line.start_with?('ActiveRecord::Schema')
      end

      def process_schema_line(line, schema, state)
        return process_create_table(line, schema, state) if create_table_line?(line)
        return process_column(line, state) if state[:current_table] && column_line?(line)
        return process_add_index(line, schema, state) if add_index_line?(line)
        return process_add_foreign_key(line, schema, state) if add_foreign_key_line?(line)

        save_and_reset_table(schema, state) if end_of_table_line?(line, state)
      end

      def create_table_line?(line)
        line.match?(/create_table\s+["'](\w+)["']/)
      end

      def column_line?(line)
        line.match?(/^t\.(\w+)\s+["'](\w+)["']/)
      end

      def add_index_line?(line)
        line.match?(/add_index\s+["'](\w+)["']/)
      end

      def add_foreign_key_line?(line)
        line.match?(/add_foreign_key\s+["'](\w+)["']/)
      end

      def end_of_table_line?(line, state)
        line == 'end' && state[:current_table]
      end

      def process_create_table(line, schema, state)
        save_current_table(schema, state) if state[:current_table]

        match = line.match(/create_table\s+["'](\w+)["']/)
        state[:current_table] = match[1]
        state[:table_columns] = []
        state[:table_constraints] = []

        state[:table_constraints] << 'FORCE: cascade' if line.match?(/force:\s*:cascade/)
      end

      def process_column(line, state)
        match = line.match(/^t\.(\w+)\s+["'](\w+)["']/)
        column_type = match[1]
        column_name = match[2]

        column_def = build_column_definition(line, column_name, column_type)
        state[:table_columns] << column_def
      end

      def build_column_definition(line, column_name, column_type)
        null_option = line.match(/null:\s*(true|false)/)
        default_option = line.match(/default:\s*([^,}]+)/)
        limit_option = line.match(/limit:\s*(\d+)/)

        sql_type = map_rails_type_to_sql(column_type, limit_option&.[](1))
        definition = build_column_definition_string(column_name, sql_type, null_option, default_option)

        {
          name: column_name,
          type: sql_type,
          definition: definition
        }
      end

      def build_column_definition_string(column_name, sql_type, null_option, default_option)
        definition = "#{column_name} #{sql_type}"
        definition += ' NOT NULL' if null_option && null_option[1] == 'false'
        definition += " DEFAULT #{extract_default_value(default_option&.[](1))}" if default_option
        definition
      end

      def process_add_index(line, schema, state)
        match = line.match(/add_index\s+["'](\w+)["']/)
        table_name = match[1]
        columns_match = line.match(/\[([^\]]+)\]/)

        return unless columns_match

        constraint = build_index_constraint(line, table_name, columns_match)
        add_constraint_to_table(schema, state, table_name, constraint)
      end

      def build_index_constraint(line, table_name, columns_match)
        columns = columns_match[1].split(',').map(&:strip).map { |c| c.gsub(/["']/, '') }
        name_match = line.match(/name:\s*["']([^"']+)["']/)
        unique_match = line.match(/unique:\s*(true)/)

        index_name = name_match ? name_match[1] : "index_#{table_name}_on_#{columns.join('_and_')}"
        constraint = unique_match ? "UNIQUE INDEX #{index_name}" : "INDEX #{index_name}"
        "#{constraint} (#{columns.join(', ')})"
      end

      def process_add_foreign_key(line, schema, state)
        match = line.match(/add_foreign_key\s+["'](\w+)["'],\s*["'](\w+)["']/)
        return unless match

        from_table = match[1]
        to_table = match[2]
        column = extract_foreign_key_column(line, to_table)

        constraint = "FOREIGN KEY (#{column}) REFERENCES #{to_table}(id)"
        add_constraint_to_table(schema, state, from_table, constraint)
      end

      def extract_foreign_key_column(line, to_table)
        column_match = line.match(/column:\s*["'](\w+)["']/)
        return column_match[1] if column_match

        to_table.end_with?('s') ? "#{to_table[0..-2]}_id" : "#{to_table}_id"
      end

      def add_constraint_to_table(schema, state, table_name, constraint)
        if schema[table_name]
          schema[table_name][:constraints] << constraint
        elsif table_name == state[:current_table]
          state[:table_constraints] << constraint
        end
      end

      def save_and_reset_table(schema, state)
        save_current_table(schema, state)
        state[:current_table] = nil
        state[:table_columns] = []
        state[:table_constraints] = []
      end

      def save_current_table(schema, state)
        return unless state[:current_table]

        schema[state[:current_table]] = {
          columns: state[:table_columns],
          constraints: state[:table_constraints]
        }
      end

      def filter_system_tables(schema)
        schema.reject! { |k, _| %w[schema_migrations ar_internal_metadata].include?(k) }
        schema
      end

      def map_rails_type_to_sql(rails_type, limit = nil)
        type_map = build_type_map(limit)
        type_map[rails_type] || rails_type.upcase
      end

      def build_type_map(limit)
        base_types.merge('string' => string_type(limit))
      end

      def base_types
        numeric_types.merge(text_types).merge(date_types).merge(other_types)
      end

      def numeric_types
        {
          'integer' => 'INTEGER',
          'bigint' => 'BIGINT',
          'float' => 'FLOAT',
          'decimal' => 'DECIMAL'
        }
      end

      def text_types
        {
          'text' => 'TEXT',
          'binary' => 'BLOB'
        }
      end

      def date_types
        {
          'datetime' => 'DATETIME',
          'timestamp' => 'TIMESTAMP',
          'time' => 'TIME',
          'date' => 'DATE'
        }
      end

      def other_types
        {
          'boolean' => 'BOOLEAN',
          'json' => 'JSON',
          'jsonb' => 'JSONB'
        }
      end

      def string_type(limit)
        limit ? "VARCHAR(#{limit})" : 'VARCHAR(255)'
      end

      def extract_default_value(default_str)
        return 'NULL' if default_str.nil?

        default_str = default_str.strip
        # Remove quotes if present
        default_str = default_str.gsub(/^["']|["']$/, '')
        # Check if it's a number
        return default_str if default_str.match?(/^\d+$/)
        # Check if it's a boolean
        return default_str if %w[true false].include?(default_str)

        # Otherwise return as string
        "'#{default_str}'"
      end
    end
  end
end
