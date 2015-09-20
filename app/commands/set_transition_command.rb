class SetTransitionCommand
  include ActiveModel::Model
  include DomainObjectConversion

  attr_accessor :project_id_str, :phase_name, :state_names

  validates :project_id_str, presence: true
  validates :phase_name, presence: true
  validates :state_names, transition: true

  def transition
    Activity::Transition.from_array(state_names)
  end

  def execute(service)
    return false unless valid?
    service.set_transition(project_id, phase, transition)
  end
end
