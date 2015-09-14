class SpecifyWorkflowCommand
  include ActiveModel::Model

  attr_accessor :project_id_str, :phase_name, :wip_limit

  validates :project_id_str, presence: true
  validates :phase_name, presence: true
  validates :wip_limit, presence: true

  def execute(service)
  end
end
