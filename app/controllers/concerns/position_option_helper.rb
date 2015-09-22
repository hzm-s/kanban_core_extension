module PositionOptionHelper
  POSITIONS = { 'before' => '前', 'after' => '後' }.freeze

  def position_name
    POSITIONS[position]
  end

  def option_for_state(base_state_name)
    { position.to_sym => Activity::State.new(base_state_name) }
  end

  def option_for_phase(base_phase_name)
    { position.to_sym => Activity::Phase.new(base_phase_name) }
  end

  def position
    fail '`position` is not implemented'
  end
end
