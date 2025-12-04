# frozen_string_literal: true

require 'rails/generators'

module MagicQuery
  module Rails
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        source_root File.expand_path('templates', __dir__)

        desc 'Installs Magic Query configuration files'

        def create_initializer
          template 'initializer.rb', 'config/initializers/magic_query.rb'
        end

        def create_rules_file
          template 'magic_query.yml', 'config/magic_query.yml'
        end

        def add_routes
          route "mount MagicQuery::Rails::Engine => '/magic_query'"
        end
      end
    end
  end
end
