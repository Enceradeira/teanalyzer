require File.expand_path('./../hand_parameters', __FILE__)

class HandsParameters
  attr_accessor :left,:right, :hand_penalty_weight, :finger_penalty_weight
  def initialize
    @left = HandParameters.new
    @right = HandParameters.new
  end
end