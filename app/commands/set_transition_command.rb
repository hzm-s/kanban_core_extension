class SetTransitionCommand
  include ActiveModel::Model
  include DomainObjectConversion

  attr_accessor :project_id_str, :phase_name, :state_names

  validates :project_id_str, presence: true
  validates :phase_name, presence: true
  validates :state_names, transition: true

  def states
    state_names.map {|state_name| Activity::State.new(state_name) }
  end

  def execute(service)
    return false unless valid?
    service.set_transition(project_id, phase, states)
  rescue Activity::DuplicateState
    errors.add(:base, '状態が重複しています。')
    false
  rescue Activity::TransitionAlreadySetted
    errors.add(:base, '既に遷移が設定されています。')
    false
  else
    true
  end
end
