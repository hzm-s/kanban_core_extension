class RemovePhaseSpecCommand
  include ActiveModel::Model

  attr_accessor :project_id_str, :phase_name

  def project_id
    Project::ProjectId.new(project_id_str)
  end

  def phase
    Project::Phase.new(phase_name)
  end

  def execute(service)
    service.remove_phase_spec(project_id, phase)
  end
end
