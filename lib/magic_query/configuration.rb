# frozen_string_literal: true

module MagicQuery
  class Configuration
    attr_accessor :provider, :api_key, :model, :schema_path, :rules_path,
                  :database_url, :base_prompt, :temperature, :max_tokens

    PROVIDER_MAP = {
      openai: ['providers/openai', 'OpenAI'],
      claude: ['providers/claude', 'Claude'],
      gemini: ['providers/gemini', 'Gemini']
    }.freeze

    def initialize
      @provider = :openai
      @api_key = nil
      @model = nil
      @schema_path = nil
      @rules_path = nil
      @database_url = nil
      @base_prompt = nil
      @temperature = 0.3
      @max_tokens = 1000
    end

    def provider_class
      provider_info = PROVIDER_MAP[provider.to_sym]
      raise Error, "Unknown provider: #{provider}" unless provider_info

      require_relative provider_info[0]
      Providers.const_get(provider_info[1])
    end
  end
end
