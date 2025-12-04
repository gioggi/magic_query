# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/magic_query/providers/base'
require_relative '../../../lib/magic_query/providers/claude'

RSpec.describe MagicQuery::Providers::Claude do
  let(:api_key) { 'test-api-key' }
  let(:provider) { described_class.new(api_key: api_key) }

  describe '#generate' do
    let(:prompt) { 'Generate a SQL query' }
    let(:response_body) do
      {
        'content' => [
          {
            'text' => 'SELECT * FROM users'
          }
        ]
      }
    end

    before do
      stub_request(:post, 'https://api.anthropic.com/v1/messages')
        .with(
          headers: {
            'x-api-key' => api_key,
            'anthropic-version' => '2023-06-01',
            'Content-Type' => 'application/json'
          }
        )
        .to_return(status: 200, body: response_body.to_json)
    end

    it 'makes a request to Claude API' do
      provider.generate(prompt)
      expect(WebMock).to have_requested(:post, 'https://api.anthropic.com/v1/messages')
    end

    it 'returns the generated content' do
      result = provider.generate(prompt)
      expect(result).to eq('SELECT * FROM users')
    end

    context 'when API returns an error' do
      before do
        stub_request(:post, 'https://api.anthropic.com/v1/messages')
          .to_return(status: 401, body: { 'error' => 'Unauthorized' }.to_json)
      end

      it 'raises an error' do
        expect { provider.generate(prompt) }.to raise_error(MagicQuery::Error, /Claude API error/)
      end
    end
  end

  describe '#default_model' do
    it 'returns claude-3-5-sonnet-20241022' do
      expect(provider.send(:default_model)).to eq('claude-3-5-sonnet-20241022')
    end
  end

  describe '#generate_headers' do
    it 'returns correct api key header' do
      headers = provider.send(:generate_headers)
      expect(headers['x-api-key']).to eq(api_key)
    end

    it 'returns correct anthropic version header' do
      headers = provider.send(:generate_headers)
      expect(headers['anthropic-version']).to eq('2023-06-01')
    end

    it 'returns correct content type header' do
      headers = provider.send(:generate_headers)
      expect(headers['Content-Type']).to eq('application/json')
    end
  end

  describe '#generate_body' do
    let(:prompt) { 'Generate a SQL query' }

    it 'returns body with correct model' do
      body = provider.send(:generate_body, prompt)
      expect(body[:model]).to eq(provider.model)
    end

    it 'returns body with correct max_tokens' do
      body = provider.send(:generate_body, prompt)
      expect(body[:max_tokens]).to eq(provider.max_tokens)
    end

    it 'returns body with correct temperature' do
      body = provider.send(:generate_body, prompt)
      expect(body[:temperature]).to eq(provider.temperature)
    end

    it 'returns body with system as string' do
      body = provider.send(:generate_body, prompt)
      expect(body[:system]).to be_a(String)
    end

    it 'returns body with messages as array' do
      body = provider.send(:generate_body, prompt)
      expect(body[:messages]).to be_an(Array)
    end

    it 'returns body with correct message role' do
      body = provider.send(:generate_body, prompt)
      expect(body[:messages].first[:role]).to eq('user')
    end

    it 'returns body with correct message content' do
      body = provider.send(:generate_body, prompt)
      expect(body[:messages].first[:content]).to eq(prompt)
    end
  end

  describe '#generate_params' do
    let(:prompt) { 'Generate a SQL query' }

    it 'returns empty hash' do
      expect(provider.send(:generate_params, prompt)).to eq({})
    end
  end
end
