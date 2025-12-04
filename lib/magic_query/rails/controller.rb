# frozen_string_literal: true

module MagicQuery
  module Rails
    # Base controller for Magic Query endpoints.
    # Provides a RESTful endpoint for generating SQL queries from natural language.
    #
    # For detailed documentation, examples, and customization options, see CONTROLLER.md
    class MagicQueryController < ActionController::Base
      before_action :set_generator
      before_action :set_magic_query_params

      def generate
        if @user_input.blank?
          render json: { error: 'Query parameter is required' }, status: :bad_request
          return
        end

        generate_sql_with_error_handling
      end

      protected

      # Generates SQL from user input with error handling.
      # Override this method to customize error handling behavior.
      #
      # @example Custom error handling
      #   def generate_sql_with_error_handling
      #     sql = @generator.generate(@user_input)
      #     render json: { sql: sql, query: @user_input }
      #   rescue MagicQuery::Error => e
      #     # Custom error handling
      #     render json: { error: e.message }, status: :unprocessable_entity
      #   end
      #
      # @return [void]
      def generate_sql_with_error_handling
        sql = @generator.generate(@user_input)
        render json: { sql: sql, query: @user_input }
      rescue MagicQuery::Error => e
        render json: { error: e.message }, status: :unprocessable_entity
      rescue StandardError => e
        render json: { error: "An error occurred: #{e.message}" }, status: :internal_server_error
      end

      # Sets the user input from request parameters.
      # Override this method to customize how input parameters are read.
      #
      # By default, it reads from `params[:input]` or falls back to `params[:query]`.
      #
      # @example Custom parameter source
      #   def set_magic_query_params
      #     @user_input = params[:custom_input] || params[:text]
      #   end
      #
      # @return [void]
      def set_magic_query_params
        @user_input = params[:input] || params[:query]
      end

      # Sets up the query generator instance.
      # Override this method to customize generator configuration.
      #
      # @example Custom configuration
      #   def set_generator
      #     custom_config = MagicQuery::Configuration.new
      #     custom_config.provider = :custom_provider
      #     @generator = MagicQuery::QueryGenerator.new(custom_config)
      #   end
      #
      # @return [void]
      def set_generator
        @generator = MagicQuery::QueryGenerator.new(MagicQuery.configuration)
      end
    end
  end
end
