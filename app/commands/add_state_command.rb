class AddStateCommand
  include ActiveModel::Model

  attr_accessor :project_id_str, :phase_name, :state_name

  validates :project_id_str, presence: true
  validates :state_name, presence: true

  def project_id
    Project::ProjectId.new(project_id_str)
  end

  def phase
    Project::Phase.new(phase_name)
  end

  def state
    Project::State.new(state_name)
  end

  def execute(service)
    return false unless valid?
    service.add_state(project_id, phase, state)
  end
end