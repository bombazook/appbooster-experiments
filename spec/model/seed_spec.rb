# frozen_string_literal: true

RSpec.describe Model::Seed, redis: true do
  subject { described_class.new(experiments_list: experiments_list) }

  let(:experiment1) { instance_spy(Algorithms::Weighted, call: 1) }
  let(:experiment2) { instance_spy(Algorithms::Weighted, call: 2) }
  let(:experiments_list) do
    { experiment1: experiment1, experiment2: experiment2 }
  end

  describe '#call' do
    let(:key) { 'example_key' }
    let(:experiment) { :experiment1 }

    it 'calls selected experiments' do
      subject.call(key, experiment)
      expect(experiment1).to have_received(:call).at_least(1)
    end

    it 'doesn\'t call other experiments' do
      subject.call(key, experiment)
      expect(experiment2).not_to have_received(:call)
    end

    it 'returns same result for same key' do
      first = subject.call(key, experiment)
      second = subject.call(key, experiment)
      expect(first).to be_eql(second)
    end

    it 'increments counter only once on concurrent calls' do
      50.times do
        fork do
          allow(subject).to(receive(:call).and_wrap_original { |m, *args| m.call(*args); exit(0) })
          subject.call(key, experiment)
        end
      end
      Process.waitall
      expect(App['persistence.redis'].get("counter.experiment:#{experiment}")).to be_eql('1')
    end
  end
end
