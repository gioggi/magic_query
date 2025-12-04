# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MagicQuery::Configuration do
  describe '#initialize' do
    it 'sets default provider' do
      config = described_class.new
      expect(config.provider).to eq(:openai)
    end

    it 'sets default temperature' do
      config = described_class.new
      expect(config.temperature).to eq(0.3)
    end

    it 'sets default max_tokens' do
      config = described_class.new
      expect(config.max_tokens).to eq(1000)
    end
  end

  describe '#provider_class' do
    context 'with openai provider' do
      it 'returns OpenAI provider class' do
        config = described_class.new
        config.provider = :openai
        expect(config.provider_class).to eq(MagicQuery::Providers::OpenAI)
      end
    end

    context 'with claude provider' do
      it 'returns Claude provider class' do
        config = described_class.new
        config.provider = :claude
        expect(config.provider_class).to eq(MagicQuery::Providers::Claude)
      end
    end

    context 'with gemini provider' do
      it 'returns Gemini provider class' do
        config = described_class.new
        config.provider = :gemini
        expect(config.provider_class).to eq(MagicQuery::Providers::Gemini)
      end
    end

    context 'with unknown provider' do
      it 'raises an error' do
        config = described_class.new
        config.provider = :unknown
        expect { config.provider_class }.to raise_error(MagicQuery::Error, /Unknown provider/)
      end
    end
  end
end
