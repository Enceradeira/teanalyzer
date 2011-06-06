require File.expand_path('./../../app/teanalyzer', __FILE__)

describe 'Teanalyzer' do
  describe 'calculate' do
    context 'typing' do
      it 'should be between 0 and 1' do
        effort = Teanalyzer.calculate('typing')
        effort.should >= 0.0
        effort.should <= 1.0
      end
    end
  end
end