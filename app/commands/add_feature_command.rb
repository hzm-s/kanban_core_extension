class AddFeatureCommand
  include ActiveModel::Model
  include DomainObjectConversion

  attr_accessor :project_id_str, :summary, :detail

  validates :summary, presence: true
  validates :detail, presence: true

  def description
    Feature::Description.new(summary, detail)
  end

  def execute(service)
    return false unless valid?
    service.add(project_id, description)
  end
end
