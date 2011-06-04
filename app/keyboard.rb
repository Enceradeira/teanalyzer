# encoding: utf-8
require File.expand_path('./../hand', __FILE__)
require File.expand_path('./../key', __FILE__)
require File.expand_path('./../parameters', __FILE__)

class Keyboard
  private
  def self.configure_keys
    p = @parameters

    keys = []
    # 4th row from left to right
    # keys << Key.new('¬`¦', 5.0, :left, :forth_row, :finger_0, p) # problem with encoding but it's an unimportant one anyway
    keys << Key.new('!1', 5.0, :left, :forth_row, :finger_0, p)
    keys << Key.new('"2', 4.0, :left, :forth_row, :finger_1, p)
    keys << Key.new('£3', 4.0, :left, :forth_row, :finger_2, p)
    keys << Key.new('$4€', 4.0, :left, :forth_row, :finger_3, p)
    keys << Key.new('%5', 3.5, :left, :forth_row, :finger_3, p)
    keys << Key.new('^6', 4.5, :right, :forth_row, :finger_6, p)
    keys << Key.new('&7', 4.0, :right, :forth_row, :finger_6, p)
    keys << Key.new('*8', 4.0, :right, :forth_row, :finger_7, p)
    keys << Key.new('(9', 4.0, :right, :forth_row, :finger_8, p)
    keys << Key.new(')0', 4.0, :right, :forth_row, :finger_9, p)
    keys << Key.new('_-', 4.0, :right, :forth_row, :finger_9, p)
    keys << Key.new('+=', 4.5, :right, :forth_row, :finger_9, p)
    # 3th row from left to right
    keys << Key.new('Qq', 2.0, :left, :third_row, :finger_0, p)
    keys << Key.new('Ww', 2.0, :left, :third_row, :finger_1, p)
    keys << Key.new('Ee', 2.0, :left, :third_row, :finger_2, p)
    keys << Key.new('Rr', 2.0, :left, :third_row, :finger_3, p)
    keys << Key.new('Tt', 2.5, :left, :third_row, :finger_3, p)
    keys << Key.new('Yy', 3.0, :right, :third_row, :finger_6, p)
    keys << Key.new('Uu', 2.0, :right, :third_row, :finger_6, p)
    keys << Key.new('Ii', 2.0, :right, :third_row, :finger_7, p)
    keys << Key.new('Oo', 2.0, :right, :third_row, :finger_8, p)
    keys << Key.new('Pp', 2.0, :right, :third_row, :finger_9, p)
    keys << Key.new('{[', 2.5, :right, :third_row, :finger_9, p)
    keys << Key.new('}]', 4.0, :right, :third_row, :finger_9, p)
    # 2nd row from left to right
    keys << Key.new('Aa', 0.0, :left, :second_row, :finger_0, p)
    keys << Key.new('Ss', 0.0, :left, :second_row, :finger_1, p)
    keys << Key.new('Dd', 0.0, :left, :second_row, :finger_2, p)
    keys << Key.new('Ff', 0.0, :left, :second_row, :finger_3, p)
    keys << Key.new('Gg', 2.0, :left, :second_row, :finger_3, p)
    keys << Key.new('Hh', 2.0, :right, :second_row, :finger_6, p)
    keys << Key.new('Jj', 0.0, :right, :second_row, :finger_6, p)
    keys << Key.new('Kk', 0.0, :right, :second_row, :finger_7, p)
    keys << Key.new('Ll', 0.0, :right, :second_row, :finger_8, p)
    keys << Key.new(':;', 0.0, :right, :second_row, :finger_9, p)
    keys << Key.new("@'", 2.0, :right, :second_row, :finger_9, p)
    keys << Key.new('~#', 2.5, :right, :second_row, :finger_9, p)
    # 1th row from left to right
    keys << Key.new('|\\', 2.0, :left, :first_row, :finger_0, p)
    keys << Key.new('Zz', 2.0, :left, :first_row, :finger_0, p)
    keys << Key.new('Xx', 2.0, :left, :first_row, :finger_1, p)
    keys << Key.new('Cc', 2.0, :left, :first_row, :finger_2, p)
    keys << Key.new('Vv', 2.0, :left, :first_row, :finger_3, p)
    keys << Key.new('Bb', 3.5, :left, :first_row, :finger_3, p)
    keys << Key.new('Nn', 2.0, :right, :first_row, :finger_6, p)
    keys << Key.new('Mm', 2.0, :right, :first_row, :finger_6, p)
    keys << Key.new('<,', 2.0, :right, :first_row, :finger_7, p)
    keys << Key.new('>.', 2.0, :right, :first_row, :finger_8, p)
    keys << Key.new('?/', 2.0, :right, :first_row, :finger_9, p)

    @key_index = {}
    keys.each do |k|
      k.chars.each do |c|
        if @key_index[c] != nil
          raise ArgumentError, "#{c} is defined more than once"
        end
        @key_index[c] = k
      end
    end
  end

  def self.initialize
    configure_defaults
    configure_keys
  end

  def self.configure_defaults
    @parameters = Parameters.new
  end

  initialize

  public
  def self.configure
    yield @parameters if block_given?
  end

  def self.get_key_for(key_char)
    key = @key_index[key_char]
  end
end