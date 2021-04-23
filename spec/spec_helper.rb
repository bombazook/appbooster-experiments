# frozen_string_literal: true

require 'simplecov'
require_relative 'shared/redis_helper'
SimpleCov.start do
  add_filter %r{^/spec/}
end

require_relative '../config/boot'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.include RSpec::RedisHelper, redis: true

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.disable_monkey_patching!
  config.warnings = true
  config.profile_examples = 10

  config.order = :random

  Kernel.srand config.seed
end
