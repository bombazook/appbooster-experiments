# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Queries::Experiment do
  describe '.call' do
    it 'returns 422 on Device-Token absence' do
      expect(subject.call({})[0]).to be_eql(422)
    end

    it 'returns 200 if device-token given' do
      expect(subject.call('device-token': 'some token')[0]).to be_eql(200)
    end
  end
end
