# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MagicQuery::Prompt::Builder do
  let(:config) { MagicQuery::Configuration.new }
  let(:schema) do
    {
      'users' => {
        columns: [
          { name: 'id', type: 'INTEGER' },
          { name: 'name', type: 'VARCHAR(255)' }
        ],
        constraints: []
      }
    }
  end
  let(:rules) do
    {
      naming_conventions: { column_naming: 'snake_case' },
      relationships: ['users has_many posts']
    }
  end
  let(:builder) { described_class.new(config, schema, rules) }

  describe '#build' do
    it 'includes base prompt' do
      result = builder.build('test query')
      expect(result).to include('expert SQL developer')
    end

    it 'includes schema information' do
      result = builder.build('test query')
      expect(result).to include('users')
    end

    it 'includes schema column information' do
      result = builder.build('test query')
      expect(result).to include('id')
    end

    it 'includes naming conventions' do
      result = builder.build('test query')
      expect(result).to include('snake_case')
    end

    it 'includes relationships' do
      result = builder.build('test query')
      expect(result).to include('has_many')
    end

    it 'includes user input' do
      user_input = 'find all active users'
      result = builder.build(user_input)
      expect(result).to include(user_input)
    end
  end
end
