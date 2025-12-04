# frozen_string_literal: true

module MagicQuery
  module Rails
    module Routes
      def self.draw(router)
        router.post 'magic_query/generate', to: 'magic_query#generate', as: :magic_query_generate
      end
    end
  end
end
