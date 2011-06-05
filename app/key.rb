class Key
  private
  def pHand
    case @hand
      when :left
        @parameters.hands.left.penalty
      when :right
        @parameters.hands.right.penalty
      else
        raise ArgumentError, @hand
    end
  end

  def pRow
    case @row
      when :first_row
        @parameters.rows.row_1_penalty_bottom
      when :second_row
        @parameters.rows.row_2_penalty_home
      when :third_row
        @parameters.rows.row_3_penalty
      when :forth_row
        @parameters.rows.row_4_penalty_top
      else
        raise ArgumentError, @row
    end
  end

  def pFinger
    case @finger
      when :finger_0
        @parameters.hands.left.finger_0_penalty
      when :finger_1
        @parameters.hands.left.finger_1_penalty
      when :finger_2
        @parameters.hands.left.finger_2_penalty
      when :finger_3
        @parameters.hands.left.finger_3_penalty
      when :finger_4
        @parameters.hands.left.finger_4_penalty
      when :finger_5
        @parameters.hands.right.finger_0_penalty
      when :finger_6
        @parameters.hands.right.finger_1_penalty
      when :finger_7
        @parameters.hands.right.finger_2_penalty
      when :finger_8
        @parameters.hands.right.finger_3_penalty
      when :finger_9
        @parameters.hands.right.finger_4_penalty
      else
        raise ArgumentError, @finger
    end
  end

  public
  attr_reader :chars, :distance, :hand, :row

  def initialize chars, distance, hand, row, finger, parameters
    @chars = chars.chars.sort
    @distance = distance
    @parameters = parameters
    @hand = hand
    @row = row
    @finger = finger
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
    p = @parameters
    w0 = p.default_penalty
    w_hand = p.hands_penalty_weight
    w_row = p.rows_penalty_weight
    w_finger = p.fingers_penalty_weight
    (w0 + w_hand * pHand + w_row * pRow + w_finger * pFinger)
  end
end