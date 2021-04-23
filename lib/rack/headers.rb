# frozen_string_literal: true

module Rack
  class Headers
    include Import[inflector: 'common.inflector']

    def initialize(app, ...)
      super(...)
      @app = app
    end

    def call(env)
      env['rack.http_headers'] = env.select { |k, _| k =~ /^HTTP_/ }.transform_keys do |k|
        k = k.sub(/^HTTP_/, '')
        inflector.dasherize(k.downcase)
      end

      @app.call(env)
    end
  end
end
