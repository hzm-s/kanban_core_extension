class AddPhaseSpecCommand
  include ActiveModel::Model

  attr_accessor :project_id_str, :phase_name, :wip_limit_count,
                :direction, :base_phase_name

  validates :project_id_str, presence: true
  validates :phase_name, presence: true
  validates :wip_limit_count, presence: true

  def project_id
    Project::ProjectId.new(project_id_str)
  end

  def wip_limit
    if wip_limit_count.to_i > 0
      Project::WipLimit.new(wip_limit_count)
    else
      Project::WipLimit::None.new
    end
  end

  def phase_spec
    Project::PhaseSpec.new(
      phase_name,
      Project::Transition::None.new,
      wip_limit
    )
  end

  def position_option
    return nil if direction.nil? || base_phase_name.nil?
    { direction.to_sym => Project::Phase.new(base_phase_name) }
  end

  def execute(service)
    return false unless valid?
    service.add_phase_spec(project_id, phase_spec, position_option)
  end
end
