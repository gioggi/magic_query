# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MagicQuery::Query::Parser do
  describe '.extract_sql' do
    context 'with SQL in markdown code block' do
      it 'extracts SQL from markdown' do
        response = "Here's your query:\n```sql\nSELECT * FROM users\n```"
        result = described_class.extract_sql(response)
        expect(result).to eq('SELECT * FROM users')
      end
    end

    context 'with direct SQL statement' do
      it 'extracts SQL directly' do
        response = 'SELECT * FROM users WHERE id = 1'
        result = described_class.extract_sql(response)
        expect(result).to eq('SELECT * FROM users WHERE id = 1')
      end
    end

    context 'with SQL ending with semicolon' do
      it 'removes trailing semicolon' do
        response = 'SELECT * FROM users;'
        result = described_class.extract_sql(response)
        expect(result).to eq('SELECT * FROM users')
      end
    end

    context 'with plain text response' do
      it 'returns the text as-is' do
        response = 'SELECT * FROM users'
        result = described_class.extract_sql(response)
        expect(result).to eq('SELECT * FROM users')
      end
    end
  end
end
