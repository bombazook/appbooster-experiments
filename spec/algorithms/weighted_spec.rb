# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Algorithms::Weighted do
  describe '.weights' do
    it 'returns empty hash by default' do
      expect(subject.weights).to be_eql({})
    end
  end

  describe '.variant' do
    it 'adds new weight' do
      subject.variant 'value', 3
      expect(subject.weights).to be_eql({ 'value' => 3 })
    end
  end

  describe '.initialize' do
    subject { described_class.new(variants: variants) }

    let(:variants) { { 'some' => 4, 'values' => 8 } }

    it 'can set variants by :variants key' do
      expect(subject.variants).to be_eql variants
    end

    it 'calls #variant for each variant value' do
      expect_any_instance_of(described_class).to receive(:variant).with('some', 4)
      expect_any_instance_of(described_class).to receive(:variant).with('values', 8)
      subject
    end
  end

  describe '#plan' do
    subject { described_class.new(variants: variants).plan }

    let(:variants) { { 'some' => 4, 'values' => 8 } }

    it 'returns minimal list of values that corresponds weights' do
      expect(subject).to contain_exactly('values', 'values', 'some')
    end
  end

  describe '#call' do
    subject { described_class.new(variants: variants) }

    let(:seed) { rand(100) }
    let(:variants) { { 'some' => 4, 'values' => 8 } }

    it 'returns variant value picked from plan by remainder from seed divided by plan size' do
      plan_size = subject.plan.size
      expect(subject.call(seed)).to be_eql(subject.plan[seed % plan_size])
    end
  end
end
