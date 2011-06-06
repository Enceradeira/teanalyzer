require File.expand_path('./../../lib/keyboard', __FILE__)
require File.expand_path('./../../lib/parameters', __FILE__)

describe 'Keyboard' do
  describe 'get_key_for' do
    it '#z should return z-Key' do
      Keyboard.get_key_for('z').should ==(Key.new('Zz', 9, :left, :first_row, :finger_0))
    end
  end
end