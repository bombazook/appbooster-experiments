# frozen_string_literal: true

module Queries
  class Stats
    include Import[stats: 'model.stats']

    def call
      [200, { 'Content-Type' => 'application/json' }, stats.call.to_json]
    end
  end
end
