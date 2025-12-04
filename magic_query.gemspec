# frozen_string_literal: true

require_relative 'lib/magic_query/version'

Gem::Specification.new do |spec|
  spec.name          = 'magic_query'
  spec.version       = MagicQuery::VERSION
  spec.authors       = ['Giovanni Esposito']
  spec.email         = ['info@giovanniesposito.it']

  spec.summary       = 'A Ruby gem that generates SQL queries using AI (OpenAI, Claude, Gemini)'
  spec.description   = 'Magic Query integrates with OpenAI, Claude, and Gemini to generate SQL SELECT queries ' \
                       'from natural language input, using database schema and configuration rules.'
  spec.homepage      = 'https://github.com/yourusername/magic_query'
  spec.license       = 'Apache-2.0'

  spec.files         = Dir['lib/**/*', 'README.md', 'LICENSE', 'CHANGELOG.md', '.rubocop.yml']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.3.0'

  spec.add_dependency 'activesupport', '>= 6.0'
  spec.add_dependency 'faraday', '~> 2.0'

  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'rspec-rails', '~> 6.0'
  spec.add_development_dependency 'rubocop', '~> 1.81'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.25'
  spec.add_development_dependency 'simplecov', '~> 0.22'
  spec.add_development_dependency 'webmock', '~> 3.18'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
