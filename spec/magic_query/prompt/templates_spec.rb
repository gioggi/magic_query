# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MagicQuery::Prompt::Templates do
  describe '.base_prompt' do
    it 'loads prompt from base_prompt.txt file' do
      result = described_class.base_prompt
      expect(result).to include('expert SQL developer')
    end

    it 'includes SQL SELECT in prompt' do
      result = described_class.base_prompt
      expect(result).to include('SQL SELECT')
    end

    it 'includes Rules section in prompt' do
      result = described_class.base_prompt
      expect(result).to include('Rules:')
    end
  end

  describe '.format_schema' do
    context 'with empty schema' do
      it 'returns empty string for nil' do
        expect(described_class.format_schema(nil)).to eq('')
      end

      it 'returns empty string for empty hash' do
        expect(described_class.format_schema({})).to eq('')
      end
    end

    context 'with valid schema' do
      let(:schema) do
        {
          'users' => {
            columns: [
              { name: 'id', type: 'INTEGER' },
              { name: 'name', type: 'VARCHAR(255)' }
            ],
            constraints: ['PRIMARY KEY (id)']
          },
          'posts' => {
            columns: %w[title content],
            constraints: []
          }
        }
      end

      it 'includes database schema header' do
        result = described_class.format_schema(schema)
        expect(result).to include('Database Schema:')
      end

      it 'includes users table name' do
        result = described_class.format_schema(schema)
        expect(result).to include('Table: users')
      end

      it 'includes posts table name' do
        result = described_class.format_schema(schema)
        expect(result).to include('Table: posts')
      end

      it 'includes id column definition' do
        result = described_class.format_schema(schema)
        expect(result).to include('id: INTEGER')
      end

      it 'includes name column definition' do
        result = described_class.format_schema(schema)
        expect(result).to include('name: VARCHAR(255)')
      end

      it 'includes constraints' do
        result = described_class.format_schema(schema)
        expect(result).to include('PRIMARY KEY (id)')
      end

      it 'includes title column name' do
        result = described_class.format_schema(schema)
        expect(result).to include('title')
      end

      it 'includes content column name' do
        result = described_class.format_schema(schema)
        expect(result).to include('content')
      end
    end
  end

  describe '.format_rules' do
    context 'with empty rules' do
      it 'returns empty string for nil' do
        expect(described_class.format_rules(nil)).to eq('')
      end

      it 'returns empty string for empty hash' do
        expect(described_class.format_rules({})).to eq('')
      end
    end

    context 'with valid rules' do
      let(:rules) do
        {
          naming_conventions: { column_naming: 'snake_case', table_naming: 'plural' },
          relationships: ['users has_many posts', 'posts belongs_to users'],
          business_rules: ['Active users have status = "active"'],
          tables: {
            'users' => { 'soft_delete' => true },
            'posts' => { 'published_only' => true }
          }
        }
      end

      it 'includes database rules header' do
        result = described_class.format_rules(rules)
        expect(result).to include('Database Rules and Conventions:')
      end

      it 'includes naming conventions header' do
        result = described_class.format_rules(rules)
        expect(result).to include('Naming Conventions:')
      end

      it 'formats column naming convention' do
        result = described_class.format_rules(rules)
        expect(result).to include('column_naming: snake_case')
      end

      it 'formats table naming convention' do
        result = described_class.format_rules(rules)
        expect(result).to include('table_naming: plural')
      end

      it 'includes relationships header' do
        result = described_class.format_rules(rules)
        expect(result).to include('Relationships:')
      end

      it 'formats user relationships' do
        result = described_class.format_rules(rules)
        expect(result).to include('users has_many posts')
      end

      it 'formats post relationships' do
        result = described_class.format_rules(rules)
        expect(result).to include('posts belongs_to users')
      end

      it 'includes business rules header' do
        result = described_class.format_rules(rules)
        expect(result).to include('Business Rules:')
      end

      it 'formats business rule content' do
        result = described_class.format_rules(rules)
        expect(result).to include('Active users have status = "active"')
      end

      it 'includes table-specific rules header' do
        result = described_class.format_rules(rules)
        expect(result).to include('Table-specific Rules:')
      end

      it 'includes users table name in rules' do
        result = described_class.format_rules(rules)
        expect(result).to include('users:')
      end

      it 'formats users table rule value' do
        result = described_class.format_rules(rules)
        expect(result).to include('soft_delete: true')
      end

      it 'includes posts table name in rules' do
        result = described_class.format_rules(rules)
        expect(result).to include('posts:')
      end

      it 'formats posts table rule value' do
        result = described_class.format_rules(rules)
        expect(result).to include('published_only: true')
      end
    end

    context 'with partial rules' do
      let(:rules) do
        {
          naming_conventions: { column_naming: 'snake_case' }
        }
      end

      it 'includes naming conventions when provided' do
        result = described_class.format_rules(rules)
        expect(result).to include('Naming Conventions:')
      end

      it 'includes column naming when provided' do
        result = described_class.format_rules(rules)
        expect(result).to include('column_naming: snake_case')
      end

      it 'excludes relationships when not provided' do
        result = described_class.format_rules(rules)
        expect(result).not_to include('Relationships:')
      end

      it 'excludes business rules when not provided' do
        result = described_class.format_rules(rules)
        expect(result).not_to include('Business Rules:')
      end
    end
  end
end
