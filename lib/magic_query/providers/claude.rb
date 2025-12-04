# frozen_string_literal: true

require 'json'
require_relative 'base'

module MagicQuery
  module Providers
    class Claude < Base
      API_URL = 'https://api.anthropic.com/v1/messages'

      def generate(prompt)
        response = http_client.post(API_URL) do |req|
          generate_headers.each { |key, value| req.headers[key] = value }
          req.body = generate_body(prompt)
        end

        handle_response(response)
      end

      protected

      def default_model
        'claude-3-5-sonnet-20241022'
      end

      def generate_params(_prompt)
        {}
      end

      def generate_headers
        {
          'x-api-key' => api_key,
          'anthropic-version' => '2023-06-01',
          'Content-Type' => 'application/json'
        }
      end

      def generate_body(prompt)
        {
          model: model,
          max_tokens: max_tokens,
          temperature: temperature,
          system: base_prompt,
          messages: [
            { role: 'user', content: prompt }
          ]
        }
      end

      private

      def handle_response(response)
        raise Error, "Claude API error: #{response.status} - #{response.body}" unless response.status == 200

        body = response.body.is_a?(String) ? JSON.parse(response.body) : response.body
        body.dig('content', 0, 'text')
      end
    end
  end
end
