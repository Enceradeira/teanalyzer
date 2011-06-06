require File.expand_path('./../keyboard', __FILE__)


class Triad
  private
  def alternating_hand?
    keys_hand { |h1, h2, h3| h1!=h2 && h2 != h3 }
  end

  def same_hand?
    keys_hand { |h1, h2, h3| h1==h2 && h2 == h3 }
  end

  def keys selector
    [selector.call(@keys[0]), selector.call(@keys[1]), selector.call(@keys[2])]
  end

  def keys_key &block
    keys_accessor(lambda { |k| k }, &block)
  end

  def keys_row_idx &block
    keys_accessor(lambda { |k| k.row_idx }, &block)
  end

  def keys_hand &block
    keys_accessor(lambda { |k| k.hand }, &block)
  end

  def keys_distance &block
    keys_accessor(lambda { |k| k.distance }, &block)
  end

  def keys_penalty &block
    keys_accessor(lambda { |k| k.penalty }, &block)
  end

  def keys_accessor(accessor, &block)
    t = keys(accessor)
    block.call(t[0], t[1], t[2])
  end

  #fingers
  def all_fingers_same(k1, k2, k3)
    k1.finger_idx == k2.finger_idx && k2.finger_idx == k3.finger_idx
  end

  def all_fingers_different(k1, k2, k3)
    k1.finger_idx != k2.finger_idx && k2.finger_idx != k3.finger_idx && k1.finger_idx != k3.finger_idx
  end

  def some_fingers_different(k1, k2, k3)
    fingers = [k1.finger_idx, k2.finger_idx, k3.finger_idx].sort
    a = fingers[0]
    b = fingers[1]
    c = fingers[2]
    (a == b && b != c) || (a != b && b == c)
  end

  def fingers_progress_right(k1, k2, k3)
    (k1.finger_idx <= k2.finger_idx && k2.finger_idx <= k3.finger_idx)
  end

  def fingers_progress_left(k1, k2, k3)
    (k1.finger_idx >= k2.finger_idx && k2.finger_idx >= k3.finger_idx)
  end

  def monotonic_progression(k1, k2, k3)
    fingers_progress_right(k1, k2, k3) || fingers_progress_left(k1, k2, k3)
  end

  def finger_rolling_right(k1, k2, k3)
    k1.finger_idx < k3.finger_idx && k3.finger_idx < k2.finger_idx
  end

  def finger_rolling_left(k1, k2, k3)
    k1.finger_idx > k3.finger_idx && k3.finger_idx > k2.finger_idx
  end

  def finger_rolling(k1, k2, k3)
    finger_rolling_left(k1, k2, k3) || finger_rolling_right(k1, k2, k3)
  end

  def middle_left_right(k1, k2, k3)
    # e.g: nep
    k2.finger_idx < k1.finger_idx && k1.finger_idx < k3.finger_idx
  end

  def middle_right_left(k1, k2, k3)
    # e.g: dhx
    k3.finger_idx < k1.finger_idx && k1.finger_idx < k2.finger_idx
  end

  def not_monotonic(k1, k2, k3)
    middle_left_right(k1, k2, k3) || middle_right_left(k1, k2, k3)
  end

  def not_monotonic_progression(k1, k2, k3)
    k1.finger_idx != k2.finger_idx && k1.finger_idx == k3.finger_idx
  end

  #keys
  def no_key_repeats(k1, k2, k3)
    k1 != k2 && k2 != k3 && k1 != k3
  end

  def some_keys_repeat(k1, k2, k3)
    k1 == k2 || k2 == k3
  end

  def all_keys_different(k1, k2, k3)
    k1 != k2 && k2 != k3 && k1 != k3
  end

  public
  OVERLAP = 2

  def initialize(char1, char2, char3)
    @char1 = char1
    @char2 = char2
    @char3 = char3
    @keys = [Keyboard.get_key_for(@char1), Keyboard.get_key_for(@char2), Keyboard.get_key_for(@char3)]
  end

  def text
    @char1 + @char2 + @char3
  end

  def hand_effort
    if alternating_hand?
      1
    elsif same_hand?
      2
    else
      0
    end
  end


  def cant_determine_effort(effort_type, i1, i2, i3)
    raise ArgumentError, "can't determine #{effort_type} for combination (#{i1},#{i2},#{i3})"
  end

  def row_effort
    if keys_row_idx { |i1, i2, i3| (i1 != i2 && i2 != i3) && [(i1-i2), (i2-i3)].min < -1 }
      # some different, not monotonic, max row change upward > 1
      7
    elsif keys_row_idx { |i1, i2, i3| i1 < i2 && i2 < i3 }
      # upward progression
      6
    elsif keys_row_idx { |i1, i2, i3| (i1 != i2 && i2 != i3) && [(i1-i2), (i2-i3)].max > 1 }
      # some different, not monotonic, max row change downward > 1
      5
    elsif  keys_row_idx { |i1, i2, i3| i1 > i2 && i2 > i3 }
      # downward progression
      4
    elsif keys_row_idx { |i1, i2, i3| i1 != i2 && (i1 - i2).abs == 1 && i1 == i3 }
      # some different, not monotonic, max row change 1
      3
    elsif keys_row_idx { |i1, i2, i3| i1 == i2 && i2 < i3 || i1 < i2 && i2 == i3 }
      # upward progression, with repetition
      2
    elsif keys_row_idx { |i1, i2, i3| i1 == i2 && i2 > i3 || i1 > i2 && i2 == i3 }
      # downward progression, with repetition
      1
    elsif keys_row_idx { |i1, i2, i3| i1 == i2 && i2 == i3 }
      #same
      0
    else
      keys_row_idx { |i1, i2, i3| cant_determine_effort('row_effort', i1, i2, i3) }
    end
  end

  def finger_effort
    if keys_key { |k1, k2, k3| all_fingers_same(k1, k2, k3) && all_keys_different(k1, k2, k3) }
      # same, no key repeat
      7
    elsif keys_key { |k1, k2, k3| some_fingers_different(k1, k2, k3) && no_key_repeats(k1, k2, k3) && monotonic_progression(k1, k2, k3) }
      # some different, no key repeat, monotonic progression
      6
    elsif keys_key { |k1, k2, k3| all_fingers_same(k1, k2, k3) && (k1 == k2 || k2 == k3 || k1 == k3) }
      # same, key repeat
      5
    elsif keys_key { |k1, k2, k3| some_fingers_different(k1, k2, k3) && not_monotonic_progression(k1, k2, k3) }
      # some different, not monotonic progression'
      4
    elsif keys_key { |k1, k2, k3| all_fingers_different(k1, k2, k3) && not_monotonic(k1, k2, k3) }
      # all different, not monotonic
      3
    elsif keys_key { |k1, k2, k3| finger_rolling(k1, k2, k3) }
      # rolling
      2
    elsif keys_key { |k1, k2, k3| some_fingers_different(k1, k2, k3) && some_keys_repeat(k1, k2, k3) && monotonic_progression(k1, k2, k3) }
      # some different, key repeat, monotonic progression
      1
    elsif keys_key { |k1, k2, k3| all_fingers_different(k1, k2, k3) && (monotonic_progression(k1, k2, k3)) }
      # all different, monotonic progression
      0
    else
      keys_key { |k1, k2, k3| cant_determine_effort('finger_effort', k1.chars, k2.chars, k3.chars) }
    end
  end

  def base_effort
    p = Parameters.instance
    keys_distance { |d1, d2, d3| p.key_1_weight*d1*(1+p.key_2_weight*d2*(1+p.key_3_weight*d3)) }
  end

  def penalty_effort
    p = Parameters.instance
    keys_penalty { |d1, d2, d3| p.key_1_weight*d1*(1+p.key_2_weight*d2*(1+p.key_3_weight*d3)) }
  end

  def path_effort
    p = Parameters.instance
    (hand_effort * p.hands_stroke_path_weight +
        row_effort * p.rows_stroke_path_weight +
        finger_effort * p.rows_finger_path_weight)
  end

  def ==(another)
    if another == nil
      false
    else
      self.text == another.text
    end
  end

  def self.from_word(word)
    if word == nil
      return []
    end
    first = word.chars
    second = first.drop(3-OVERLAP)
    third = second.drop(3-OVERLAP)
    first.zip(second.zip(third)).
        select { |e| e[0] != nil && e[1] != nil && e[1][0] != nil && e[1][1] != nil }.
        map { |e| Triad.new(e[0], e[1][0], e[1][1]) }
  end
end