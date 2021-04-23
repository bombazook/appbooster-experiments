# frozen_string_literal: true

module Model
  class Seed
    include Import[redis: 'persistence.redis']
    include Import[experiments_list: 'experiments']

    def call(id, experiment)
      return nil unless experiments_list.key? experiment

      seed_key = "client:#{id}.seed:#{experiment}"
      counter = "counter.experiment:#{experiment}"
      counters_lock = "lock:client:#{id}.experiment:#{experiment}"
      value = setnx_value(seed_key, counter, counters_lock, experiment)
      check_value_counters(counters_lock, experiment, value)
      value
    end

    private

    def get_value(seed_key, experiment)
      seed = redis.get(seed_key)
      seed && experiments_list[experiment].call(seed)
    end

    def setnx_value(seed_key, counter, counters_lock, experiment)
      value = nil
      until value
        redis.watch(seed_key) do |rd|
          break if rd.exists?(seed_key)

          rd.multi do |multi|
            multi.incr(counter)
            multi.set(counters_lock, 1)
            multi.copy(counter, seed_key)
          end
        end
        value = get_value(seed_key, experiment)
      end
      value
    end

    def check_value_counters(lock, experiment, value)
      value_counters = "counter.experiment:#{experiment}.values"
      redis.watch(lock) do |rd|
        break unless rd.exists?(lock)

        rd.multi do |multi|
          multi.hincrby value_counters, value, 1
          multi.del lock
        end
      end
    end
  end
end
