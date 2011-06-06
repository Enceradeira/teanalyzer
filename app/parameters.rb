require File.expand_path('./../hands_parameters', __FILE__)
require File.expand_path('./../rows_parameters', __FILE__)

class Parameters
  public
  attr_accessor :default_penalty, :hands, :rows, :hands_penalty_weight, :rows_penalty_weight, :fingers_penalty_weight
  attr_accessor :hands_stroke_path_weight, :rows_stroke_path_weight, :rows_finger_path_weight
  attr_accessor :key_1_weight, :key_2_weight, :key_3_weight
  attr_accessor :base_effort_weight, :penalty_effort_weight, :stroke_path_effort_weight

  def initialize
    @default_penalty = 0.0
    @hands = HandsParameters.new
    @rows = RowsParameters.new

    # effort component weights
    @base_effort_weight = 1.0
    @penalty_effort_weight = 1.0
    @stroke_path_effort_weight = 1.0

    # key weights (in triple)
    @key_1_weight = 1.0
    @key_2_weight = 1.0
    @key_3_weight = 1.0

    # penalty weights
    @hands_penalty_weight = 0.0
    @rows_penalty_weight = 1.0
    @fingers_penalty_weight = 2.0

    # stroke path weights
    @hands_stroke_path_weight = 1.0
    @rows_stroke_path_weight = 0.3
    @rows_finger_path_weight = 0.3

    # row penalty
    @rows.row_1_penalty_bottom = 1.0
    @rows.row_2_penalty_home = 0.0
    @rows.row_3_penalty = 0.0
    @rows.row_4_penalty_top = 0.0

    # hand penalty
    @hands.left.penalty = 1.0
    @hands.right.penalty = 1.0

    # finger penalty
    @hands.left.finger_0_penalty = 2.0
    @hands.left.finger_1_penalty = 1.0
    @hands.left.finger_2_penalty = 0.0
    @hands.left.finger_3_penalty = 0.0
    @hands.left.finger_4_penalty = 0.0

    @hands.right.finger_5_penalty = 2.0
    @hands.right.finger_6_penalty = 1.0
    @hands.right.finger_7_penalty = 0.0
    @hands.right.finger_8_penalty = 0.0
    @hands.right.finger_9_penalty = 0.0


  end

  @@instance = Parameters.new

  def self.instance
    @@instance
  end

  def self.reset
    @@instance = Parameters.new
  end

  def self.configure
    yield self.instance if block_given?
  end
end