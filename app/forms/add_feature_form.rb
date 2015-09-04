class AddFeatureForm
  include ActiveModel::Model

  attr_accessor :project_id_str, :summary, :detail

  validates :summary, presence: true
  validates :detail, presence: true

  def project_id
    Project::ProjectId.new(project_id_str)
  end

  def description
    Feature::Description.new(summary, detail)
  end

  def prefer(service)
    service.add(project_id, description)
  end
end
