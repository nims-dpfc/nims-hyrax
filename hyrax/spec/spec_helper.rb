require 'simplecov'
SimpleCov.start 'rails' do
  # additional code coverage groups for Hyrax
  add_group 'Actors', 'app/actors'
  add_group 'Forms', 'app/forms'
  add_group 'Indexers', 'app/indexers'
  add_group 'Inputs', 'app/inputs'
  add_group 'Presenters', 'app/presenters'
  add_group 'Renderers', 'app/renderers'
  add_group 'Services', 'app/services'
end
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
