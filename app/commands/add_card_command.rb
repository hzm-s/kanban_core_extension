class AddCardCommand
  include ActiveModel::Model
  include DomainObjectConversion

  attr_accessor :project_id_str, :feature_id_str

  validates :project_id_str, presence: true
  validates :feature_id_str, presence: true

  def execute(service)
    return false unless valid?

    service.add_card(project_id, feature_id)

  rescue Activity::WipLimitReached
    errors.add(:base, 'WIP制限です。')
    false
  else
    true
  end
end
