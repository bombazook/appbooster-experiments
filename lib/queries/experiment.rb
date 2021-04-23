# frozen_string_literal: true

module Queries
  class Experiment
    include Import[contract: 'contracts.experiment_headers']
    include Dry::Monads[:result]
    include Import[client: 'model.client']
    include Import[stats: 'model.stats']

    def call(headers)
      case contract.call(headers).to_monad
      in Success(result)
        [200, { 'Content-Type' => 'application/json' }, client.call(result.values['device-token']).to_json]
      in Failure(result)
        [422, { 'Content-Type' => 'application/json' }, { errors: result.errors.to_h }.to_json]
      end
    end
  end
end
