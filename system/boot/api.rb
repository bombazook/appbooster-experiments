# frozen_string_literal: true

App.boot(:api) do |_app|
  init do
    require 'hanami/api'
  end
end
