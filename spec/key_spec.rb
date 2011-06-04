require File.expand_path('./../../app/key', __FILE__)

describe 'Key' do
  context 'bB' do
    subject { Key.new 'bB',1}
    describe '==' do
      it '#Bb should be ==' do
        (subject == Key.new('Bb',1)).should be(true)
      end
      it '#g should not be == ' do
         (subject == Key.new('g',2)).should be(false)
      end
      it '#nil should not be == ' do
          (subject == nil).should be(false)
      end
    end
  end
end