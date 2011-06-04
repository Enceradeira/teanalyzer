require File.expand_path('./../keyboard', __FILE__)


class Triad
  OVERLAP = 2
  K1 = 1
  K2 = 1
  K3 = 1

  def initialize(char1, char2, char3)
    @char1 = char1
    @char2 = char2
    @char3 = char3
  end

  def text
    @char1 + @char2 + @char3
  end

  def base_effort
    b1 = Keyboard.get_effort(@char1)
    b2 = Keyboard.get_effort(@char2)
    b3 = Keyboard.get_effort(@char3)
    K1*b1*(1+K2*b2*(1+K3*b3))
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