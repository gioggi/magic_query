# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/magic_query/providers/base'
require_relative '../../../lib/magic_query/providers/gemini'

RSpec.describe MagicQuery::Providers::Gemini do
  let(:api_key) { 'test-api-key' }
  let(:provider) { described_class.new(api_key: api_key) }

  describe '#generate' do
    let(:prompt) { 'Generate a SQL query' }
    let(:response_body) do
      {
        'candidates' => [
          {
            'content' => {
              'parts' => [
                {
                  'text' => 'SELECT * FROM users'
                }
              ]
            }
          }
        ]
      }
    end

    before do
      stub_request(:post, /generativelanguage\.googleapis\.com/)
        .with(
          query: { 'key' => api_key },
          headers: {
            'Content-Type' => 'application/json'
          }
        )
        .to_return(status: 200, body: response_body.to_json)
    end

    it 'makes a request to Gemini API' do
      provider.generate(prompt)
      expect(WebMock).to have_requested(:post, /generativelanguage\.googleapis\.com/)
    end

    it 'returns the generated content' do
      result = provider.generate(prompt)
      expect(result).to eq('SELECT * FROM users')
    end

    context 'when API returns an error' do
      before do
        stub_request(:post, /generativelanguage\.googleapis\.com/)
          .to_return(status: 401, body: { 'error' => 'Unauthorized' }.to_json)
      end

      it 'raises an error' do
        expect { provider.generate(prompt) }.to raise_error(MagicQuery::Error, /Gemini API error/)
      end
    end
  end

  describe '#default_model' do
    it 'returns gemini-1.5-flash-latest' do
      expect(provider.send(:default_model)).to eq('gemini-1.5-flash-latest')
    end
  end

  describe '#generate_params' do
    let(:prompt) { 'Generate a SQL query' }

    it 'returns correct params' do
      params = provider.send(:generate_params, prompt)
      expect(params['key']).to eq(api_key)
    end
  end

  describe '#generate_headers' do
    it 'returns correct headers' do
      headers = provider.send(:generate_headers)
      expect(headers['Content-Type']).to eq('application/json')
    end
  end

  describe '#generate_body' do
    let(:prompt) { 'Generate a SQL query' }

    it 'returns body with contents as array' do
      body = provider.send(:generate_body, prompt)
      expect(body[:contents]).to be_an(Array)
    end

    it 'returns body with parts as array' do
      body = provider.send(:generate_body, prompt)
      expect(body[:contents].first[:parts]).to be_an(Array)
    end

    it 'returns body with prompt in text' do
      body = provider.send(:generate_body, prompt)
      expect(body[:contents].first[:parts].first[:text]).to include(prompt)
    end

    it 'returns body with correct temperature config' do
      body = provider.send(:generate_body, prompt)
      expect(body[:generationConfig][:temperature]).to eq(provider.temperature)
    end

    it 'returns body with correct maxOutputTokens config' do
      body = provider.send(:generate_body, prompt)
      expect(body[:generationConfig][:maxOutputTokens]).to eq(provider.max_tokens)
    end
  end
end
