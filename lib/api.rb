# frozen_string_literal: true

class Api < Hanami::API
  get '/stats' do
    App['queries.stats'].call
  end

  get '/experiment' do
    App['queries.experiment'].call(env['rack.http_headers'])
  end
end
