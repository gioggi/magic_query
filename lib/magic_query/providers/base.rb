# frozen_string_literal: true

require 'faraday'

module MagicQuery
  module Providers
    class Base
      attr_reader :api_key, :model, :temperature, :max_tokens

      def initialize(api_key:, model: nil, temperature: 0.3, max_tokens: 1000)
        @api_key = api_key
        @model = model || default_model
        @temperature = temperature
        @max_tokens = max_tokens
      end

      def generate(prompt)
        raise NotImplementedError, 'Subclasses must implement #generate'
      end

      protected

      def default_model
        raise NotImplementedError, 'Subclasses must implement #default_model'
      end

      def base_prompt
        @base_prompt ||= begin
          prompt_file = File.join(__dir__, '..', 'prompt', 'base_prompt.txt')
          File.read(prompt_file).strip
        end
      end

      def generate_params(prompt)
        raise NotImplementedError, 'Subclasses must implement #generate_params'
      end

      def generate_headers
        raise NotImplementedError, 'Subclasses must implement #generate_headers'
      end

      def generate_body(prompt)
        raise NotImplementedError, 'Subclasses must implement #generate_body'
      end

      def http_client
        @http_client ||= Faraday.new do |conn|
          conn.request :json
          conn.response :json
          conn.adapter Faraday.default_adapter
        end
      end
    end
  end
end
