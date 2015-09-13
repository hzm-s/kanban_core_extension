class ChangeWipLimitCommand
  include ActiveModel::Model

  attr_accessor :project_id_str, :phase_name, :wip_limit_count

  validates :project_id_str, presence: true
  validates :phase_name, presence: true
  validates :wip_limit_count,
            presence: true,
            numericality: { greater_than: 0 }

  def project_id
    Project::ProjectId.new(project_id_str)
  end

  def phase
    Project::Phase.new(phase_name)
  end

  def new_wip_limit
    Project::WipLimit.new(wip_limit_count.to_i)
  end

  def execute(service)
    return false unless valid?
    service.change_wip_limit(project_id, phase, new_wip_limit)

  rescue Project::UnderCurrentWip
    errors.add(:base, "新しいWIP制限の値は、作業中のカード枚数以上にしてください")
    false
  else
    true
  end
end
