class Keyboard
  def self.get_effort(key_char)
    if '¬`¦!1'.include?(key_char)
      5.0
    elsif '^6+='.include?(key_char)
      4.5
    elsif '"2£3$4&7*8(9)0_-}]'.include?(key_char)
      4.0
    elsif '%5bB'.include?(key_char)
      3.5
    elsif 'yY'.include?(key_char)
      3.0
    elsif 'tT{[~#'.include?(key_char)
      2.5
    elsif "qQwWeErRuUiIoOpPgGhH'@zZxXcCvVnNmM<,>.?/".include?(key_char)
      2.0
    elsif 'aAsSdDfFjJkKlL;:'.include?(key_char)
      0.0
    else
      5.0
    end
  end
end