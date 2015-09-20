class AddStateCommand
  include ActiveModel::Model
  include PositionOptionHelper

  attr_accessor :project_id_str, :phase_name, :state_name,
                :position, :base_state_name

  validates :project_id_str, presence: true
  validates :state_name, presence: true
  validates :position, presence: true
  validates :base_state_name, presence: true

  def describe
    "「#{phase_name}」フェーズの「#{base_state_name}」の#{position_name}に状態を追加"
  end

  def project_id
    Project::ProjectId.new(project_id_str)
  end

  def phase
    Activity::Phase.new(phase_name)
  end

  def state
    Activity::State.new(state_name)
  end

  def position_option
    option_for_state(base_state_name)
  end

  def execute(service)
    return false unless valid?
    service.add_state(project_id, phase, state, position_option)
  rescue Activity::DuplicateState
    errors.add(:base, '同じ状態が既にあります。')
    false
  else
    true
  end
end
