# frozen_string_literal: true

MagicQuery.configure do |config|
  # AI Provider configuration
  # Options: :openai, :claude, :gemini
  config.provider = :openai

  # API Key for the selected provider
  config.api_key = ENV.fetch('MAGIC_QUERY_API_KEY', nil)

  # Model to use (optional, will use default for provider if not set)
  # config.model = 'gpt-4o-mini'

  # Schema configuration
  # Option 1: Load automatically from Rails db/schema.rb (default if schema_path is not set)
  # The schema will be automatically loaded from db/schema.rb file
  # config.schema_path = nil  # Leave nil to use automatic Rails schema loading

  # Option 2: Load from file (SQL or YAML)
  # config.schema_path = Rails.root.join('config', 'schema.sql').to_s

  # Option 3: Load from database URL (requires database-specific implementation)
  # config.database_url = ENV['DATABASE_URL']

  # Rules configuration
  config.rules_path = Rails.root.join('config', 'magic_query.yml').to_s

  # AI generation parameters
  config.temperature = 0.3
  config.max_tokens = 1000

  # Custom base prompt (optional)
  # config.base_prompt = 'Your custom prompt here'
end
