class Hand
  attr_reader :finger0, :finger1, :finger2, :finger3, :finger4

  def initialize penalty, finger_0_penalty, finger_1_penalty, finger_2_penalty, finger_3_penalty, finger_4_penalty
    @penalty = penalty
    @finger0 = Finger.new(finger_0_penalty)
    @finger1 = Finger.new(finger_1_penalty)
    @finger2 = Finger.new(finger_2_penalty)
    @finger3 = Finger.new(finger_3_penalty)
    @finger4 = Finger.new(finger_4_penalty)
  end
end