require File.expand_path('./../../app/keyboard', __FILE__)

describe 'Keyboard' do
  describe 'get_effort' do
    it '#z should return 2' do
      Keyboard.get_effort('z').should ==(2.0)
    end
    it '#Z should return 2' do
      Keyboard.get_effort('Z').should ==(2.0)
    end
    it '#b should return 3.5' do
      Keyboard.get_effort('b').should ==(3.5)
    end

    it '/ should return 2' do
      Keyboard.get_effort('/').should ==(2.0)
    end
    it '? should return 2' do
      Keyboard.get_effort('?').should ==(2.0)
    end
    it '| should return 5' do
      Keyboard.get_effort('|').should ==(5.0)
    end
  end
end