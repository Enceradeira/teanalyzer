class HandParameters
  attr_accessor :penalty, :finger_0_penalty, :finger_1_penalty, :finger_2_penalty, :finger_3_penalty, :finger_4_penalty

  def method_missing(method, *args)
    match = method.to_s().scan(%r{^finger_(\d)_penalty([=])?$})
    if match.length >= 1
      first_match = match[0]
      accessor = ''
      accessor = first_match[1] unless first_match.length <= 1
      self.send("finger_#{first_match[0].to_i-5}_penalty#{accessor}", *args)
    else
      super
    end
  end
end