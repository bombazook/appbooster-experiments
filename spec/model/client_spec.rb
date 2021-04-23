# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Model::Client, redis: true do
  subject { described_class.new(seed: seed, experiments_list: experiments_list) }

  let(:seed) { spy(Model::Seed) }
  let(:experiment1) { instance_double(Algorithms::Weighted, call: 1) }
  let(:experiment2) { instance_double(Algorithms::Weighted, call: 2) }
  let(:experiments_list) do
    { experiment1: experiment1, experiment2: experiment2 }
  end

  describe '#call' do
    let(:key) { 'example key' }

    it 'returns the same results for same key' do
      first = subject.call(key)
      second = subject.call(key)
      expect(first).to be_eql(second)
    end

    it 'doesn\'t add client experiment if new experiment added' do
      subject.call(key)
      experiments_list[:experiment3] = instance_double(Algorithms::Weighted, call: 3)
      data = described_class.new(seed: seed, experiments_list: experiments_list).call(key)
      expect(data.keys).not_to include('experiment3')
    end

    it 'calls seed on first call' do
      subject.call(key)
      expect(seed).to have_received(:call).at_most(experiments_list.size).times
    end

    it 'call Model::Seed on one instance for concurrent calls on new value' do
      50.times.map do
        fork do
          allow(subject).to receive(:call).and_wrap_original { |m, *args| m.call(*args); exit 0 }
          subject.call(key)
        end
      end
      Process.waitall
      expect(redis.get('counter.clients')).to be_eql('1')
    end
  end
end
