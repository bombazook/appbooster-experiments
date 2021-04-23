# frozen_string_literal: true

App.boot(:persistence) do |app|
  init do
    require 'redis'
    redis = Redis.new(host: ENV['REDIS_HOST'], db: ENV['REDIS_DB'] || 'base')
    app.register('persistence.redis', redis)
  end
end
