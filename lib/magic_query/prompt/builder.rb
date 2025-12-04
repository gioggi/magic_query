# frozen_string_literal: true

require_relative 'templates'

module MagicQuery
  module Prompt
    class Builder
      def initialize(config, schema, rules)
        @config = config
        @schema = schema
        @rules = rules
      end

      def build(user_input)
        prompt_parts = []

        # Base prompt
        base_prompt = @config.base_prompt || Templates.base_prompt
        prompt_parts << base_prompt

        # Schema
        prompt_parts << Templates.format_schema(@schema) if @schema && !@schema.empty?

        # Rules
        prompt_parts << Templates.format_rules(@rules) if @rules && !@rules.empty?

        # User input
        prompt_parts << "User Request: #{user_input}"

        prompt_parts.join("\n\n")
      end
    end
  end
end
