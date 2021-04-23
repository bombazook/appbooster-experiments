# frozen_string_literal: true

require 'dry/system/container'
require_relative 'types'

class App < Dry::System::Container
  configure do |config|
    config.auto_register = %w[lib]
    config.root = File.expand_path('..', __dir__)
  end

  load_paths!('lib')
end
