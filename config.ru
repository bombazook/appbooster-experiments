# frozen_string_literal: true

require_relative './config/boot'

use Rack::Headers
run App['api']
