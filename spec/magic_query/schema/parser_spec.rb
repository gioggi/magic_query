# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MagicQuery::Schema::Parser do
  describe '.parse' do
    let(:sql_schema) do
      <<~SQL
        CREATE TABLE users (
          id INTEGER PRIMARY KEY,
          name VARCHAR(255),
          email VARCHAR(255)
        );

        CREATE TABLE posts (
          id INTEGER PRIMARY KEY,
          user_id INTEGER,
          title VARCHAR(255)
        );
      SQL
    end

    it 'parses users table' do
      result = described_class.parse(sql_schema)
      expect(result).to have_key('users')
    end

    it 'parses posts table' do
      result = described_class.parse(sql_schema)
      expect(result).to have_key('posts')
    end

    it 'extracts columns from table' do
      result = described_class.parse(sql_schema)
      expect(result['users'][:columns]).not_to be_empty
    end

    it 'extracts column names correctly' do
      result = described_class.parse(sql_schema)
      expect(result['users'][:columns].first[:name]).to eq('id')
    end
  end
end
