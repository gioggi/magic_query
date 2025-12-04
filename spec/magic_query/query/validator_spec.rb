# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MagicQuery::Query::Validator do
  describe '.validate' do
    context 'with valid SELECT query' do
      it 'returns empty errors array' do
        sql = 'SELECT * FROM users'
        errors = described_class.validate(sql)
        expect(errors).to be_empty
      end
    end

    context 'with empty SQL' do
      it 'returns error' do
        errors = described_class.validate('')
        expect(errors).to include('SQL query is empty')
      end
    end

    context 'with query not starting with SELECT' do
      it 'returns error' do
        errors = described_class.validate('UPDATE users SET name = "test"')
        expect(errors).to include('Query must start with SELECT')
      end
    end

    context 'with dangerous keywords' do
      it 'detects DROP' do
        errors = described_class.validate('DROP TABLE users')
        expect(errors).to include(match(/dangerous keyword.*DROP/i))
      end

      it 'detects DELETE' do
        errors = described_class.validate('DELETE FROM users')
        expect(errors).to include(match(/dangerous keyword.*DELETE/i))
      end

      it 'detects UPDATE' do
        errors = described_class.validate('UPDATE users SET name = "test"')
        expect(errors).to include(match(/dangerous keyword.*UPDATE/i))
      end
    end
  end

  describe '.valid?' do
    it 'returns true for valid SQL' do
      expect(described_class.valid?('SELECT * FROM users')).to be true
    end

    it 'returns false for invalid SQL' do
      expect(described_class.valid?('DROP TABLE users')).to be false
    end
  end
end
