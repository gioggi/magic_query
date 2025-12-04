# frozen_string_literal: true

require 'json'
require_relative 'base'

module MagicQuery
  module Providers
    class Gemini < Base
      API_URL_TEMPLATE = 'https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent'

      def generate(prompt)
        url = format(API_URL_TEMPLATE, model)
        response = make_request(url, prompt)
        handle_response(response)
      end

      def make_request(url, prompt)
        http_client.post(url) do |req|
          set_request_params(req, prompt)
          apply_request_headers(req)
          req.body = generate_body(prompt)
        end
      end

      def set_request_params(req, prompt)
        generate_params(prompt).each { |key, value| req.params[key] = value }
      end

      def apply_request_headers(req)
        generate_headers.each { |key, value| req.headers[key] = value }
      end

      protected

      def default_model
        'gemini-1.5-flash-latest'
      end

      def generate_params(_prompt)
        { 'key' => api_key }
      end

      def generate_headers
        {
          'Content-Type' => 'application/json'
        }
      end

      def generate_body(prompt) # rubocop:disable Metrics/MethodLength
        {
          contents: [
            {
              parts: [
                { text: "#{base_prompt}\n\n#{prompt}" }
              ]
            }
          ],
          generationConfig: {
            temperature: temperature,
            maxOutputTokens: max_tokens
          }
        }
      end

      private

      def handle_response(response)
        raise Error, "Gemini API error: #{response.status} - #{response.body}" unless response.status == 200

        body = response.body.is_a?(String) ? JSON.parse(response.body) : response.body
        body.dig('candidates', 0, 'content', 'parts', 0, 'text')
      end
    end
  end
end
