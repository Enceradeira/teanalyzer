require File.expand_path('./../../lib/triad', __FILE__)
require File.expand_path('./../../lib/keyboard', __FILE__)

describe 'Triad' do
  before(:each) do
    # set an configuration for testing purposes
    Parameters.reset
    Parameters.configure do |p|
      # weights
      p.hands_penalty_weight = 0.0
      p.rows_penalty_weight = 1.0
      p.fingers_penalty_weight = 2.0
      p.rows.row_1_penalty_bottom = 1.0

      # hand penalty
      p.hands.left.penalty = 1.0
      p.hands.right.penalty = 1.0

      # finger penalty
      p.hands.left.finger_0_penalty = 2.0
      p.hands.left.finger_1_penalty = 1.0

      p.hands.right.finger_5_penalty = 2.0
      p.hands.right.finger_6_penalty = 1.0
    end
  end
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

  describe 'from_text' do
    it '#typingishard should split in triples' do
      word = 'typingishard'
      triads = Triad.from_text(word)

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
      triads = Triad.from_text('typ')

      triads.should have(1).items
      triads.should include(Triad.new('t', 'y', 'p'))
    end
    it '#emtpy should not split' do
      triads = Triad.from_text('')

      triads.should have(0).items
    end
    it '#nil should not split' do
      triads = Triad.from_text(nil)

      triads.should have(0).items
    end
    it 'should return nil for invalid chars' do
      # ö is invalid on uk-keyboards
      triads = Triad.from_text('Jörg')

      triads.should have(0).items
    end
  end
  describe 'penalty effort' do
    it 'should add up all penalties' do
      # following configuration yields a penalty of 0.2 for every key
      Parameters.configure do |p|
        # adjust penalties in order to have the same penalty for every key (simpler test)
        p.default_penalty = 0.2
        p.hands_penalty_weight = 0.0
        p.rows_penalty_weight = 0.0
        p.fingers_penalty_weight = 0.0
        # adjust weight in order to test them
        p.key_1_weight = 0.5
        p.key_2_weight = 0.4
        p.key_3_weight = 0.3
      end
      Triad.new('a', 'b', 'c').penalty_effort.should == (0.5*0.2*(1+0.4*0.2*(1+0.3*0.2)))
    end
  end
  describe 'path_effort' do
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
        context 'bok' do
          subject { Triad.new 'b', 'o', 'k' }
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
        context 'bvb' do
          subject { Triad.new 'b', 'v', 'b' }
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

    context 'examples from carpalx' do
      before(:all) do
        Parameters.configure do |p|
          p.hands_stroke_path_weight = 1.0
          p.rows_stroke_path_weight = 0.3
          p.rows_finger_path_weight = 0.3
        end
      end
      describe 'each combination of triple once (hand,row,finger-effort)' do
        context 'no effort' do
          specify { Triad.new('a', 'd', 'j').path_effort.should be==(0) }
        end
        context 'just finger effort' do
          specify { Triad.new('a', 'a', 'h').path_effort.should be==(0.3) }
        end
        context 'just row effort' do
          specify { Triad.new('a', 'b', 'm').path_effort.should be==(0.3) }
        end
        context 'just hand effort' do
          specify { Triad.new('a', 'd', 'f').path_effort.should be==(2.0) }
        end
        context 'hand and row effort' do
          specify { Triad.new('a', 'c', 'b').path_effort.should be==(2.3) }
        end
        context 'row and finger effort' do
          specify { Triad.new('a', 'a', 'm').path_effort.should be==(0.6) }
        end
        context 'hand, row and finger effort' do
          specify { Triad.new('a', 'd', 'w').path_effort.should be==(3.2) }
        end
      end
    end
    describe 'random examples' do
      specify { Triad.new('a', 'i', 'u').path_effort.to_s.should be==(1.2).to_s }
      specify { Triad.new('b', 'c', 'm').path_effort.to_s.should be==(0.9).to_s }
      specify { Triad.new('a', 'b', 'c').path_effort.to_s.should be==(2.9).to_s }
      specify { Triad.new('a', 'f', 'w').path_effort.to_s.should be==(3.2).to_s }
      specify { Triad.new('c', 'a', 'f').path_effort.to_s.should be==(3.5).to_s }
      specify { Triad.new('e', 'f', 'm').path_effort.to_s.should be==(1.2).to_s }
      # next is right in my opinion
      specify { Triad.new('b', 'o', 'k').path_effort.to_s.should be==(2.1).to_s }
      specify { Triad.new('a', 'n', 'j').path_effort.to_s.should be==(2.7).to_s }
      specify { Triad.new('a', 'h', 'a').path_effort.to_s.should be==(2.2).to_s }
      specify { Triad.new('e', 'k', 'b').path_effort.to_s.should be==(2.8).to_s }
      specify { Triad.new('q', 'h', 'z').path_effort.to_s.should be==(3.4).to_s }
      specify { Triad.new('b', 'o', 'f').path_effort.to_s.should be==(3.7).to_s }
      specify { Triad.new('c', 'a', 'b').path_effort.to_s.should be==(3.8).to_s }
      specify { Triad.new('e', 'a', 'c').path_effort.to_s.should be==(4.4).to_s }
      specify { Triad.new('c', 'd', 'c').path_effort.to_s.should be==(4.4).to_s }
      specify { Triad.new('b', 'e', 'f').path_effort.to_s.should be==(4.7).to_s }
      specify { Triad.new('a', 'c', 'd').path_effort.to_s.should be==(4.7).to_s }
      specify { Triad.new('e', 'j', 'm').path_effort.to_s.should be==(3.0).to_s }
      specify { Triad.new('b', 'f', 'u').path_effort.to_s.should be==(3.6).to_s }
      specify { Triad.new('a', 'r', 'm').path_effort.to_s.should be==(2.1).to_s }
      specify { Triad.new('a', 'u', 'n').path_effort.to_s.should be==(3.9).to_s }
      specify { Triad.new('b', 'h', 'r').path_effort.to_s.should be==(4.0).to_s }
      specify { Triad.new('a', 'o', 'b').path_effort.to_s.should be==(3.7).to_s }
      specify { Triad.new('b', 's', 'e').path_effort.to_s.should be==(4.4).to_s }
      specify { Triad.new('f', 't', 'g').path_effort.to_s.should be==(5.0).to_s }
      specify { Triad.new('a', 'e', 'v').path_effort.to_s.should be==(4.1).to_s }
      specify { Triad.new('b', 'e', 'b').path_effort.to_s.should be==(5.3).to_s }
      specify { Triad.new('d', 'e', 'c').path_effort.to_s.should be==(6.2).to_s }
    end
    describe 'all key combinations' do
      it 'should return a number', :slow => true do
        keys = Keyboard.keys
        keys.each do |k1|
          keys.each do |k2|
            keys.each do |k3|
              c1 = k1.chars.first
              c2 = k2.chars.first
              c3 = k3.chars.first
              puts "testing triple (#{c1},#{c2},#{c3})"
              Triad.new(c1, c2, c3).path_effort.should be >= 0
            end
          end
        end
      end
    end
  end
  describe 'effort' do
    it 'should add up effort components' do
      Parameters.configure do |p|
        # adjust weight in order to test them
        p.base_effort_weight = 0.5
        p.penalty_effort_weight = 0.4
        p.stroke_path_effort_weight = 0.3
      end

      t = Triad.new('b', 'b', 'c')
      be = t.base_effort
      pe = t.penalty_effort
      sp = t.path_effort
      # validate test
      be.should > 0.0
      pe.should > 0.0
      sp.should > 0.0
      # test
      t.effort.should ==(0.5*be+0.4*pe+0.3*sp)
    end
  end
end
