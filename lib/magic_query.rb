# frozen_string_literal: true

require_relative 'magic_query/version'
require_relative 'magic_query/configuration'
require_relative 'magic_query/initializer'
require_relative 'magic_query/query_generator'

module MagicQuery
  class Error < StandardError; end

  class << self
    def configure
      yield(configuration) if block_given?
      configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def reset
      @configuration = Configuration.new
    end
  end
end
