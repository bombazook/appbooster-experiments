# frozen_string_literal: true

module Model
  class Client
    include Import[redis: 'persistence.redis']
    include Import[experiments_list: 'experiments']
    include Import[seed: 'model.seed']

    def call(id)
      experiments_key = "client:#{id}.experiments"
      clients_counter = 'counter.clients'
      until redis.exists?(experiments_key)
        redis.watch(experiments_key) do |rd|
          break if rd.exists?(experiments_key)

          rd.multi do |multi|
            multi.sadd(experiments_key, experiments_list.keys)
            multi.incr(clients_counter)
          end
        end
      end
      get_values(id, experiments_key)
    end

    def get_values(id, experiments_key)
      keys = redis.smembers(experiments_key) & experiments_list.keys.map(&:to_s)
      Hash[
        keys.map do |experiment|
          [experiment, seed.call(id, experiment)]
        end
      ]
    end
  end
end
