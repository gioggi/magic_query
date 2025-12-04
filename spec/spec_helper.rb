# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

# Set up Rails for controller tests
begin
  require 'rails'
  require 'action_controller/railtie'
  require 'rspec/rails'

  # Create a minimal Rails application for testing
  unless Rails.application
    class TestApplication < Rails::Application
      config.eager_load = false
      config.secret_key_base = 'test_secret_key_base'
      config.active_support.test_order = :random
    end

    TestApplication.initialize!
  end
rescue LoadError
  # Rails not available, skip setup
end

require 'magic_query'
require 'webmock/rspec'

# Load Rails integration if Rails is available
require_relative '../lib/magic_query/rails' if defined?(Rails)

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.disable_monkey_patching!
  config.warnings = true

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.profile_examples = 10
  config.order = :random
  Kernel.srand config.seed

  # Include Rails helpers for controller tests
  if defined?(RSpec::Rails)
    config.infer_spec_type_from_file_location!
    config.use_transactional_fixtures = false
  end
end
