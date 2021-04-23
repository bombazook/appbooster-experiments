# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Model::Stats, redis: true do
  
  subject { described_class.new(experiments_list: experiments_list) }
  let(:experiment1) { instance_double(Algorithms::Weighted, call: 1) }
  let(:experiment2) { instance_double(Algorithms::Weighted, call: 2) }
  let(:experiments_list) do
    { "experiment1" => experiment1, "experiment2" => experiment2 }
  end
  let(:seed){ Model::Seed.new(experiments_list: experiments_list) }
  let(:client) { Model::Client.new(experiments_list: experiments_list, seed: seed)}

  describe '.call' do
    it "returns total clients count" do
      client.call('test')
      expect(subject.call).to include(total: 1)
    end

    it "returns experiment key values" do
      client.call('test')
      expect(subject.call).to include("experiment1" => {"1" => 1})
    end
  end
end
