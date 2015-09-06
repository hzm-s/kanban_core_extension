class AddCardCommand
  include ActiveModel::Model

  attr_accessor :project_id_str, :feature_id_str

  validates :project_id_str, presence: true
  validates :feature_id_str, presence: true

  def project_id
    Project::ProjectId.new(project_id_str)
  end

  def feature_id
    Feature::FeatureId.new(feature_id_str)
  end

  def execute(service)
    return false unless valid?

    service.add_card(project_id, feature_id)

  rescue Kanban::WipLimitReached
    errors.add(:base, 'WIP制限です。')
    false
  else
    true
  end
end