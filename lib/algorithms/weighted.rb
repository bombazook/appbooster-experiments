# frozen_string_literal: true

module Algorithms
  class Weighted
    def variants
      @variants ||= {}
    end

    def initialize(variants: nil)
      variants&.each_pair { |key, value| variant(key, value) }
    end

    def variant(value, weight)
      variants[value] = weight
    end

    def plan
      @plan ||= begin
        gcd = gcd_of_values
        variants.each_with_object([]) { |(k, v), m| (v / gcd).times { m << k }; }
      end
    end

    def call(seed)
      index = seed.to_i % plan.size
      plan[index]
    end

    alias weights variants

    private

    def gcd_of_values
      variants.values.inject(variants.values&.first) { |m, i| m.gcd(i) }
    end
  end
end
