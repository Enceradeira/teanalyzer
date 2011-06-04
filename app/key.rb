class Key
  attr_accessor :chars, :distance

  def initialize chars, distance
    @chars = chars.chars.sort
    @distance = distance
  end


  def ==(other)
    if other == nil
      false
    else
      @chars.zip(other.chars).all? {|z| z[0] != nil && z[1] != nil && z[0] == z[1]}
    end
  end
end