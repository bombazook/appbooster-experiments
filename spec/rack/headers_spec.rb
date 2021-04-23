require 'spec_helper'

RSpec.describe Rack::Headers do
  def request env={}
    app = ->(e) { e }
    described_class.new(app).call(env)
  end

  it 'sets rack.http_headers env variable' do
    expect(request).to include('rack.http_headers')
  end

  it 'downcases HTTP_ prefixed env variables' do
    expect(request("HTTP_TEST" => "hello")).to include('rack.http_headers' => {'test' => 'hello'})
  end

  it 'dasherize HTTP_ prefixed env variables' do
    expect(request("HTTP_DEVICE_TOKEN" => "hello")).to include('rack.http_headers' => {'device-token' => 'hello'})
  end
end
