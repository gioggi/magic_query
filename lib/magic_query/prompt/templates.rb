# frozen_string_literal: true

module MagicQuery
  module Prompt
    module Templates
      def self.base_prompt
        File.read(File.join(__dir__, 'base_prompt.txt'))
      end

      def self.format_schema(schema)
        return '' if schema.nil? || schema.empty?

        schema_text = "Database Schema:\n\n"
        schema.each do |table_name, table_info|
          schema_text += format_table(table_name, table_info)
        end
        schema_text
      end

      def self.format_rules(rules)
        return '' if rules.nil? || rules.empty?

        rules_text = "Database Rules and Conventions:\n\n"
        rules_text += format_naming_conventions(rules[:naming_conventions])
        rules_text += format_relationships(rules[:relationships])
        rules_text += format_business_rules(rules[:business_rules])
        rules_text += format_table_rules(rules[:tables])
        rules_text
      end

      # Private helper methods

      def self.format_table(table_name, table_info)
        text = "Table: #{table_name}\n"
        text += format_columns(table_info[:columns])
        text += format_constraints(table_info[:constraints]) if constraints?(table_info[:constraints])
        "#{text}\n"
      end

      def self.format_columns(columns)
        return "  Columns:\n" if columns.nil? || columns.empty?

        text = "  Columns:\n"
        columns.each do |column|
          text += format_column(column)
        end
        text
      end

      def self.format_column(column)
        if column.is_a?(Hash)
          "    - #{column[:name]}: #{column[:type]}\n"
        else
          "    - #{column}\n"
        end
      end

      def self.format_constraints(constraints)
        return '' if constraints.nil? || constraints.empty?

        text = "  Constraints:\n"
        constraints.each do |constraint|
          text += "    - #{constraint}\n"
        end
        text
      end

      def self.constraints?(constraints)
        constraints && !constraints.empty?
      end

      def self.format_naming_conventions(naming_conventions)
        return '' if naming_conventions.nil? || naming_conventions.empty?

        text = "Naming Conventions:\n"
        naming_conventions.each do |key, value|
          text += "  - #{key}: #{value}\n"
        end
        text += "\n"
      end

      def self.format_relationships(relationships)
        return '' if relationships.nil? || relationships.empty?

        text = "Relationships:\n"
        relationships.each do |rel|
          text += "  - #{rel}\n"
        end
        text += "\n"
      end

      def self.format_business_rules(business_rules)
        return '' if business_rules.nil? || business_rules.empty?

        text = "Business Rules:\n"
        business_rules.each do |rule|
          text += "  - #{rule}\n"
        end
        text += "\n"
      end

      def self.format_table_rules(tables)
        return '' if tables.nil? || tables.empty?

        text = "Table-specific Rules:\n"
        tables.each do |table_name, table_rules|
          text += "  #{table_name}:\n"
          table_rules.each do |key, value|
            text += "    - #{key}: #{value}\n"
          end
        end
        text += "\n"
      end

      private_class_method :format_table, :format_columns, :format_column,
                           :format_constraints, :constraints?,
                           :format_naming_conventions, :format_relationships,
                           :format_business_rules, :format_table_rules
    end
  end
end
