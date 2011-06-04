require File.expand_path('./../keyboard', __FILE__)


class Triad
  private
  def alternating_hand?
    @keys[0].hand != @keys[1].hand && @keys[1].hand != @keys[2].hand
  end

  def save_hand?
    @keys[0].hand == @keys[1].hand && @keys[1].hand == @keys[2].hand
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
    elsif save_hand?
      2
    else
      0
    end
  end

  def base_effort
    K1*@keys[0].distance*(1+K2*@keys[1].distance*(1+K3*@keys[2].distance))
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