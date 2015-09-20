class DisableWipLimitCommand
  include ActiveModel::Model
  include DomainObjectConversion

  attr_accessor :project_id_str, :phase_name

  validates :project_id_str, presence: true
  validates :phase_name, presence: true

  def execute(service)
    return false unless valid?
    service.disable_wip_limit(project_id, phase)
  rescue Activity::PhaseNotFound
    errors.add(:base, 'フェーズが見つかりません。')
    false
  else
    true
  end
end
