module PositionOptionHelper
  DIRECTIONS = { 'before' => '前', 'after' => '後' }.freeze

  def direction_name
    DIRECTIONS[direction]
  end

  def option_for_state(base_state_name)
    { direction.to_sym => Project::State.new(base_state_name) }
  end

  def option_for_phase(base_phase_name)
    { direction.to_sym => Project::Phase.new(base_phase_name) }
  end

  def direction
    fail '`direction` is not implemented'
  end
end
