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

  def keys_row_idx
    t = keys(lambda { |k| k.row_idx })
    yield(t[0], t[1], t[2])
  end

  def keys_hand
    t = keys(lambda { |k| k.hand })
    yield(t[0], t[1], t[2])
  end

  def keys_distance
    t = keys(lambda { |k| k.distance })
    yield(t[0], t[1], t[2])
  end

  public
  OVERLAP = 2
  K1 = 1
  K2 = 1
  K3 = 1

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
      keys_row_idx { |i1, i2, i3| raise ArgumentError, "can't determine row_effort for combination (#{i1},#{i2},#{i3})" }
    end
  end

  def finger_effort
    0
  end

  def base_effort
    keys_distance { |d1, d2, d3| K1*d1*(1+K2*d2*(1+K3*d3)) }
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