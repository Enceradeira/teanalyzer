require File.expand_path('./../../lib/hand_parameters', __FILE__)

describe 'HandParameters' do
  subject { HandParameters.new }
  describe 'finger_5_penalty=' do
    it 'should assign to finger_0_penalty' do
      subject.finger_5_penalty = 7.0
      subject.finger_0_penalty.should be==(7.0)
    end
  end
  describe 'finger_5_penalty' do
    it 'should read from finger_0_penalty' do
      subject.finger_0_penalty = 2.5
      subject.finger_5_penalty.should be==(2.5)
    end
  end
end