# frozen_string_literal: true

module RSpec
  module RedisHelper
    extend Forwardable
    def_delegators :redis, :flushall

    def self.included(rspec)
      rspec.around(:each, redis: true) do |example|
        with_clean_redis do
          example.run
        end
      end
    end

    def with_clean_redis(...)
      flushall            # clean before run
      begin
        yield if block_given?
      ensure
        flushall          # clean up after run
      end
    end

    def redis
      App['persistence.redis']
    end
  end
end
