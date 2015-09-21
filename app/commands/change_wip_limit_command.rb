class ChangeWipLimitCommand
  include ActiveModel::Model
  include DomainObjectConversion

  attr_accessor :project_id_str, :phase_name, :wip_limit_count

  validates :project_id_str, presence: true
  validates :phase_name, presence: true
  validates :wip_limit_count,
            presence: true,
            numericality: { greater_than: 0 }

  alias_method :new_wip_limit, :wip_limit

  def execute(service)
    return false unless valid?
    service.change(project_id, phase, new_wip_limit)

  rescue Activity::UnderCurrentWip
    errors.add(:base, "新しいWIP制限の値は、作業中のカード枚数以上にしてください")
    false
  else
    true
  end
end
