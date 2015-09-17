class DisableWipLimitCommand
  include ActiveModel::Model

  attr_accessor :project_id_str, :phase_name

  validates :project_id_str, presence: true
  validates :phase_name, presence: true

  def project_id
    Project::ProjectId.new(project_id_str)
  end

  def phase
    Project::Phase.new(phase_name)
  end

  def execute(service)
    return false unless valid?
    service.disable_wip_limit(project_id, phase)
  rescue Project::PhaseNotFound
    errors.add(:base, 'フェーズが見つかりません。')
    false
  else
    true
  end
end
