# frozen_string_literal: true

module MagicQuery
  # Initializer helper for Rails applications
  class Initializer
    def self.setup(config = MagicQuery.configuration)
      yield(config) if block_given?
      config
    end
  end
end
