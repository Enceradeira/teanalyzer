require File.expand_path('./../../app/triad', __FILE__)
require File.expand_path('./../../app/keyboard', __FILE__)

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
      it 'should account for no effort on 1st key' do
        subject.base_effort.should ==(0)
      end
    end
  end
  context 'bac' do
    subject { Triad.new('b', 'a', 'c') }
    describe 'base_effort' do
      it 'should account for no effort on 2nd key' do
        subject.base_effort.should ==(3.5)
      end
    end
  end

  context 'bca' do
    subject { Triad.new('b', 'c', 'a') }
    describe 'base_effort' do
      it 'should account for no effort on 3th key' do
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
  describe 'hand_effort' do
    describe 'both hand used, not alternating' do
      subject { Triad.new 'e', 'e', 'm' }
      specify { subject.hand_effort.should be(0) }
      subject { Triad.new 'o', 'p', 'e' }
      specify { subject.hand_effort.should be(0) }
    end
    describe 'alternating' do
      subject { Triad.new 'a', 'j', 'a' }
      specify { subject.hand_effort.should be(1) }
      subject { Triad.new 's', 'o', 't' }
      specify { subject.hand_effort.should be(1) }
    end
    describe 'same' do
      subject { Triad.new 'a', 's', 'e' }
      specify { subject.hand_effort.should be(2) }
      subject { Triad.new 'm', 'o', 'n' }
      specify { subject.hand_effort.should be(2) }
    end
  end
  describe 'row_effort' do
    describe 'same' do
      context 'ert' do
        subject { Triad.new 'e', 'r', 't' }
        specify { subject.row_effort.should be(0) }
      end
      context 'als' do
        subject { Triad.new 'a', 'l', 's' }
        specify { subject.row_effort.should be(0) }

      end
    end
    describe 'downward progression, with repetition' do
      context 'ern' do
        subject { Triad.new 'e', 'r', 'n' }
        specify { subject.row_effort.should be(1) }
      end
      context 'kxn' do
        subject { Triad.new 'k', 'x', 'm' }
        specify { subject.row_effort.should be(1) }
      end
    end
    describe 'upward progression, with repetition' do
      context 'ade' do
        subject { Triad.new 'a', 'd', 'e' }
        specify { subject.row_effort.should be(2) }
      end
      context 'nal' do
        subject { Triad.new 'n', 'a', 'l' }
        specify { subject.row_effort.should be(2) }
      end
    end
    describe 'some different, not monotonic, max row change 1' do
      context 'aef' do
        subject { Triad.new 'a', 'e', 'f' }
        specify { subject.row_effort.should be(3) }
      end
      context 'oar' do
        subject { Triad.new 'o', 'a', 'r' }
        specify { subject.row_effort.should be(3) }
      end
      context 'cvf' do
        subject { Triad.new 'c', 'f', 'v' }
        specify { subject.row_effort.should be(3) }
      end
    end
    describe 'downward progression' do
      context 'eln' do
        subject { Triad.new 'e', 'l', 'n' }
        specify { subject.row_effort.should be(4) }
      end
      context 'pax' do
        subject { Triad.new 'p', 'a', 'x' }
        specify { subject.row_effort.should be(4) }
      end
    end
    describe 'some different, not monotonic, max row change downward > 1' do
      context 'hen' do
        subject { Triad.new 'h', 'e', 'n' }
        specify { subject.row_effort.should be(5) }
      end
      context 'kib' do
        subject { Triad.new 'k', 'i', 'b' }
        specify { subject.row_effort.should be(5) }
      end
    end
    describe 'upward progression' do
      context 'zaw' do
        subject { Triad.new 'z', 'a', 'w' }
        specify { subject.row_effort.should be(6) }
      end
      context 'nap' do
        subject { Triad.new 'n', 'a', 'p' }
        specify { subject.row_effort.should be(6) }
      end
    end
    describe 'some different, not monotonic, max row change upward >1' do
      context 'abe' do
        subject { Triad.new 'a', 'b', 'e' }
        specify { subject.row_effort.should be(7) }
      end
      context 'axe' do
        subject { Triad.new 'a', 'x', 'e' }
        specify { subject.row_effort.should be(7) }
      end
      context 'brv' do
        subject { Triad.new 'b', 'r', 'v' }
        specify { subject.row_effort.should be(7) }
      end
    end
  end
  describe 'finger_effort' do
    describe 'all different, monotonic progression' do
      context 'asd' do
        subject { Triad.new 'a', 's', 'd' }
        specify { subject.finger_effort.should be(0) }
      end
      context 'pua' do
        subject { Triad.new 'p', 'u', 'a' }
        specify { subject.finger_effort.should be(0) }
      end
    end
    describe 'some different, key repeat, monotonic progression' do
      context 'app' do
        subject { Triad.new 'a', 'p', 'p' }
        specify { subject.finger_effort.should be(1) }
      end
      context 'err' do
        subject { Triad.new 'e', 'r', 'r' }
        specify { subject.finger_effort.should be(1) }
      end
      context 'aab' do
        subject { Triad.new 'a', 'a', 'b' }
        specify { subject.finger_effort.should be(1) }
      end
    end
    describe 'rolling' do
      context 'bih' do
        subject { Triad.new 'b', 'i', 'h' }
        specify { subject.finger_effort.should be(2) }
      end
      context 'fad' do
        subject { Triad.new 'f', 'a', 'd' }
        specify { subject.finger_effort.should be(2) }
      end
    end
    describe 'all different, not monotonic' do
      context 'yak' do
        subject { Triad.new 'y', 'a', 'k' }
        specify { subject.finger_effort.should be(3) }
      end
      context 'nep' do
        subject { Triad.new 'n', 'e', 'p' }
        specify { subject.finger_effort.should be(3) }
      end
      context 'dhx' do
        subject { Triad.new 'd', 'h', 'x' }
        specify { subject.finger_effort.should be(3) }
      end
    end
    describe 'some different, not monotonic progression' do
      context 'kri' do
        subject { Triad.new 'k', 'r', 'i' }
        specify { subject.finger_effort.should be(4) }
      end
      context 'maj' do
        subject { Triad.new 'm', 'a', 'j' }
        specify { subject.finger_effort.should be(4) }
      end
      context 'aha' do
        subject { Triad.new 'a', 'h', 'a' }
        specify { subject.finger_effort.should be(4) }
      end
    end
    describe 'same, key repeat' do
      context 'cee' do
        subject { Triad.new 'c', 'e', 'e' }
        specify { subject.finger_effort.should be(5) }
      end
      context 'loo' do
        subject { Triad.new 'l', 'o', 'o' }
        specify { subject.finger_effort.should be(5) }
      end
      context 'ffg' do
        subject { Triad.new 'f', 'f', 'g' }
        specify { subject.finger_effort.should be(5) }
      end
    end
    describe 'some different, no key repeat, monotonic progression' do
      context 'abr' do
        subject { Triad.new 'a', 'b', 'r' }
        specify { subject.finger_effort.should be(6) }
      end
      context 'bde' do
        subject { Triad.new 'b', 'd', 'e' }
        specify { subject.finger_effort.should be(6) }
      end
    end
    describe 'same, no key repeat' do
      context 'tfb' do
        subject { Triad.new 't', 'f', 'b' }
        specify { subject.finger_effort.should be(7) }
      end
      context 'dec' do
        subject { Triad.new 'd', 'e', 'c' }
        specify { subject.finger_effort.should be(7) }
      end
    end
  end
  describe 'path_effort' do
    # context 'adj'
  end
end