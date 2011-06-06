require File.expand_path('./../parameters', __FILE__)

class Key
  private
  def p_hand
    p = Parameters.instance
    case @hand
      when :left
        p.hands.left.penalty
      when :right
        p.hands.right.penalty
      else
        raise ArgumentError, @hand
    end
  end

  def p_row
    p = Parameters.instance
    case @row
      when :first_row
        p.rows.row_1_penalty_bottom
      when :second_row
        p.rows.row_2_penalty_home
      when :third_row
        p.rows.row_3_penalty
      when :forth_row
        p.rows.row_4_penalty_top
      else
        raise ArgumentError, @row
    end
  end

  def p_finger
    p = Parameters.instance
    case @finger
      when :finger_0
        p.hands.left.finger_0_penalty
      when :finger_1
        p.hands.left.finger_1_penalty
      when :finger_2
        p.hands.left.finger_2_penalty
      when :finger_3
        p.hands.left.finger_3_penalty
      when :finger_4
        p.hands.left.finger_4_penalty
      when :finger_5
        p.hands.right.finger_0_penalty
      when :finger_6
        p.hands.right.finger_1_penalty
      when :finger_7
        p.hands.right.finger_2_penalty
      when :finger_8
        p.hands.right.finger_3_penalty
      when :finger_9
        p.hands.right.finger_4_penalty
      else
        raise ArgumentError, @finger
    end
  end

  public
  attr_reader :chars, :distance, :hand, :row

  def initialize chars, distance, hand, row, finger
    @chars = chars.chars.sort
    @distance = distance
    @hand = hand
    @row = row
    @finger = finger
  end

  def finger_idx
    match = @finger.to_s.scan(/^finger_(\d)$/)
    match[0][0].to_i
  end

  def row_idx
    case @row
      when :first_row
        0
      when :second_row
        1
      when :third_row
        2
      when :forth_row
        3
      else
        raise ArgumentError, @row
    end
  end

  def ==(other)
    if other == nil
      false
    else
      @chars.zip(other.chars).all? { |z| z[0] != nil && z[1] != nil && z[0] == z[1] }
    end
  end

  def penalty
    p = Parameters.instance
    w0 = p.default_penalty
    w_hand = p.hands_penalty_weight
    w_row = p.rows_penalty_weight
    w_finger = p.fingers_penalty_weight
    (w0 + w_hand * p_hand + w_row * p_row + w_finger * p_finger)
  end
end