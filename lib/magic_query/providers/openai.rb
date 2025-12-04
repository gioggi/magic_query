# frozen_string_literal: true

require 'json'
require_relative 'base'

module MagicQuery
  module Providers
    class OpenAI < Base
      API_URL = 'https://api.openai.com/v1/chat/completions'

      def generate(prompt)
        response = http_client.post(API_URL) do |req|
          generate_headers.each { |key, value| req.headers[key] = value }
          req.body = generate_body(prompt)
        end

        handle_response(response)
      end

      protected

      def default_model
        'gpt-4o-2024-08-06'
      end

      def generate_params(_prompt)
        {}
      end

      def generate_headers
        {
          'Authorization' => "Bearer #{api_key}",
          'Content-Type' => 'application/json'
        }
      end

      def generate_body(prompt)
        {
          model: model,
          messages: [
            { role: 'system', content: base_prompt },
            { role: 'user', content: prompt }
          ],
          temperature: temperature,
          max_tokens: max_tokens
        }
      end

      private

      def handle_response(response)
        raise Error, "OpenAI API error: #{response.status} - #{response.body}" unless response.status == 200

        body = response.body.is_a?(String) ? JSON.parse(response.body) : response.body
        body.dig('choices', 0, 'message', 'content')
      end
    end
  end
end
