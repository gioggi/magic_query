# frozen_string_literal: true

require_relative 'schema/loader'
require_relative 'config/rules_loader'
require_relative 'prompt/builder'
require_relative 'query/parser'
require_relative 'query/validator'

module MagicQuery
  class QueryGenerator
    def initialize(config = nil)
      @config = config || MagicQuery.configuration
      @schema = nil
      @rules = nil
    end

    def generate(user_input)
      validate_user_input(user_input)
      ensure_api_key_configured
      load_dependencies

      prompt = build_prompt(user_input)
      response = generate_ai_response(prompt)
      extract_and_validate_sql(response)
    end

    private

    def validate_user_input(user_input)
      raise Error, 'User input cannot be empty' if user_input.nil? || user_input.strip.empty?
    end

    def ensure_api_key_configured
      raise Error, 'API key not configured' if @config.api_key.nil? || @config.api_key.strip.empty?
    end

    def load_dependencies
      load_schema unless @schema
      load_rules unless @rules
    end

    def build_prompt(user_input)
      prompt_builder = Prompt::Builder.new(@config, @schema, @rules)
      prompt_builder.build(user_input)
    end

    def generate_ai_response(prompt)
      provider = create_provider
      provider.generate(prompt)
    end

    def create_provider
      provider_class = @config.provider_class
      provider_class.new(
        api_key: @config.api_key,
        model: @config.model,
        temperature: @config.temperature,
        max_tokens: @config.max_tokens
      )
    end

    def extract_and_validate_sql(response)
      sql = Query::Parser.extract_sql(response)
      validator = Query::Validator.new(sql)
      validation_errors = validator.validate
      raise Error, "Invalid SQL generated: #{validation_errors.join(', ')}" unless validation_errors.empty?

      sql
    end

    def load_schema
      # Loader will automatically detect the best source (file, Rails, or database)
      @schema = Schema::Loader.load(@config)
    end

    def load_rules
      @rules = Config::RulesLoader.load(@config.rules_path) if @config.rules_path
    end
  end
end
