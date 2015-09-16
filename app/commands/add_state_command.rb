class AddStateCommand
  include ActiveModel::Model

  attr_accessor :project_id_str, :phase_name, :state_name,
                :direction, :base_state_name

  validates :project_id_str, presence: true
  validates :state_name, presence: true
  validates :direction, presence: true
  validates :base_state_name, presence: true

  #TODO
  DIRECTIONS = { 'before' => '前', 'after' => '後' }.freeze

  def describe
    position_name = DIRECTIONS[direction]
    "「#{phase_name}」フェーズの「#{base_state_name}」の#{position_name}に状態を追加"
  end

  def project_id
    Project::ProjectId.new(project_id_str)
  end

  def phase
    Project::Phase.new(phase_name)
  end

  def state
    Project::State.new(state_name)
  end

  def position_option
    { direction.to_sym => Project::State.new(base_state_name) }
  end

  def execute(service)
    return false unless valid?
    service.add_state(project_id, phase, state, position_option)
  end
end
