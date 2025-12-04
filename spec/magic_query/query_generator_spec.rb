# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'

RSpec.describe MagicQuery::QueryGenerator do
  let(:config) do
    MagicQuery::Configuration.new.tap do |c|
      c.provider = :openai
      c.api_key = 'test-key'
      c.schema_path = schema_file.path
      c.rules_path = rules_file.path
    end
  end

  let(:schema_file) do
    file = Tempfile.new(['schema', '.sql'])
    file.write('CREATE TABLE users (id INTEGER, name VARCHAR(255));')
    file.rewind
    file
  end

  let(:rules_file) do
    file = Tempfile.new(['rules', '.yml'])
    file.write("naming_conventions:\n  column_naming: 'snake_case'")
    file.rewind
    file
  end

  let(:generator) { described_class.new(config) }

  after do
    schema_file.close!
    rules_file.close!
  end

  describe '#generate' do
    let(:ai_response) { 'SELECT * FROM users WHERE status = "active"' }

    before do
      stub_request(:post, 'https://api.openai.com/v1/chat/completions')
        .to_return(
          status: 200,
          body: {
            'choices' => [
              {
                'message' => {
                  'content' => ai_response
                }
              }
            ]
          }.to_json
        )
    end

    it 'generates SQL query from natural language' do
      result = generator.generate('find all active users')
      expect(result).to eq(ai_response)
    end

    context 'with empty input' do
      it 'raises an error' do
        expect { generator.generate('') }.to raise_error(MagicQuery::Error, /cannot be empty/)
      end
    end

    context 'when API key is missing' do
      let(:config) do
        MagicQuery::Configuration.new.tap do |c|
          c.provider = :openai
          c.api_key = nil
        end
      end

      it 'raises an error' do
        expect { generator.generate('test') }.to raise_error(MagicQuery::Error, /API key not configured/)
      end
    end
  end
end
