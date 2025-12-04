# frozen_string_literal: true

module MagicQuery
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace MagicQuery

      config.generators do |g|
        g.test_framework :rspec
        g.fixture_replacement :factory_bot, dir: 'spec/factories'
      end

      initializer 'magic_query.routes' do
        Rails.application.routes.draw do
          MagicQuery::Rails::Routes.draw(self)
        end
      end
    end
  end
end
