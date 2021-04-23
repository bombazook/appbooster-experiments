# frozen_string_literal: true

module Model
  class Stats
    include Import[redis: 'persistence.redis']
    include Import[experiments_list: 'experiments']

    def call(experiments: nil)
      experiments ||= experiments_list.keys
      experiments_data = experiments.map do |e|
        [e, redis.hgetall("counter.experiment:#{e}.values").transform_values(&:to_i)]
      end
      Hash[experiments_data].tap { |d| d[:total] = redis.get('counter.clients').to_i }
    end
  end
end
