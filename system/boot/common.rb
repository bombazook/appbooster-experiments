# frozen_string_literal: true

App.boot(:common) do |app|
  init do
    require 'dry-validation'
    require 'dry/monads'
    require 'dry/monads/do'
    require 'dry/inflector'
    app.register('common.inflector', Dry::Inflector.new)
  end

  start do
    Dry::Validation.load_extensions(:monads)
  end
end
