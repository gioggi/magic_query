# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'

RSpec.describe MagicQuery::Config::RulesLoader do
  describe '.load' do
    context 'with valid YAML file' do
      let(:yaml_content) do
        <<~YAML
          naming_conventions:
            column_naming: 'snake_case'
          relationships:
            - 'users has_many posts'
          business_rules:
            - 'Active users have status = "active"'
        YAML
      end

      let(:temp_file) do
        file = Tempfile.new(['rules', '.yml'])
        file.write(yaml_content)
        file.rewind
        file
      end

      after { temp_file.close! }

      it 'loads rules from YAML file' do
        result = described_class.load(temp_file.path)
        expect(result[:naming_conventions][:column_naming]).to eq('snake_case')
      end

      it 'includes relationships from YAML file' do
        result = described_class.load(temp_file.path)
        expect(result[:relationships]).to include('users has_many posts')
      end
    end

    context 'with non-existent file' do
      it 'returns empty hash' do
        result = described_class.load('non_existent.yml')
        expect(result).to eq({})
      end
    end

    context 'with nil path' do
      it 'returns empty hash' do
        result = described_class.load(nil)
        expect(result).to eq({})
      end
    end
  end
end
