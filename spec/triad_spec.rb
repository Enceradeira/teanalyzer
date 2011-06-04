require File.expand_path('./../../app/triad', __FILE__)

describe 'Triad' do
  context 'abc' do
    subject { Triad.new('a', 'b', 'c') }
    describe '==' do
      it '#abc should be ==' do
        (subject == Triad.new('a', 'b', 'c')).should be(true)
      end
      it '#abd should not be ==' do
        (subject == Triad.new('a', 'b', 'd')).should be(false)
      end
      it '#nil should not be ==' do
        (subject == nil).should be(false)
      end
    end
    describe 'base_effort' do
      it 'should account for no effort on 1 key' do
        subject.base_effort.should ==(0)
      end
    end
  end
  context 'bac' do
    subject { Triad.new('b', 'a', 'c') }
    describe 'base_effort' do
      it 'should account for no effort on 2 key' do
        subject.base_effort.should ==(3.5)
      end
    end
  end

  context 'bca' do
    subject { Triad.new('b', 'c', 'a') }
    describe 'base_effort' do
      it 'should account for no effort on 3 key' do
        subject.base_effort.should ==(10.5)
      end
    end
  end

  context 'bco' do
    subject { Triad.new('b', 'c', 'o') }
    describe 'base_effort' do
      it 'should account for effort on all keys' do
        subject.base_effort.should ==(24.5)
      end
    end
  end

  describe 'from_word' do
    it '#typingishard should split in triples' do
      word = 'typingishard'
      triads = Triad.from_word(word)

      triads.should have(word.length-2).items
      triads.should include(Triad.new('t', 'y', 'p'))
      triads.should include(Triad.new('y', 'p', 'i'))
      triads.should include(Triad.new('p', 'i', 'n'))
      triads.should include(Triad.new('i', 'n', 'g'))
      triads.should include(Triad.new('n', 'g', 'i'))
      triads.should include(Triad.new('g', 'i', 's'))
      triads.should include(Triad.new('i', 's', 'h'))
      triads.should include(Triad.new('s', 'h', 'a'))
      triads.should include(Triad.new('h', 'a', 'r'))
      triads.should include(Triad.new('a', 'r', 'd'))
    end
    it '#typ should split in triples' do
      triads = Triad.from_word('typ')

      triads.should have(1).items
      triads.should include(Triad.new('t', 'y', 'p'))
    end
    it '#emtpy should not split' do
      triads = Triad.from_word('')

      triads.should have(0).items
    end
    it '#nil should not split' do
      triads = Triad.from_word(nil)

      triads.should have(0).items
    end
  end
end