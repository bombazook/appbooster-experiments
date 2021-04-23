# frozen_string_literal: true

module Contracts
  class ExperimentHeaders < Dry::Validation::Contract
    params do
      required(:"device-token").filled(:string)
    end
  end
end
