# frozen_string_literal: true

require 'spec_helper'
require 'rack/mock'

RSpec.describe Api do
  subject { Rack::MockRequest.new(described_class.new) }

  describe '/stats' do
    it 'returns success' do
      response = subject.get('/stats')
      expect(response.status).to be(200)
    end
  end

  describe '/experiment' do
    it 'returns success if device-token in rack.http_headers given' do
      response = subject.get('/experiment', 'rack.http_headers' => { 'device-token' => 'some_token' })
      expect(response.status).to be(200)
    end
  end
end
