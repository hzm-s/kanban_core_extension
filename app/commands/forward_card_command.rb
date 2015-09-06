class ForwardCardCommand
  include ActiveModel::Model

  attr_accessor :project_id_str, :feature_id_str, :stage_phase_name, :stage_state_name

  validates :project_id_str, presence: true
  validates :feature_id_str, presence: true
  validates :stage_phase_name, presence: true
  validates :stage_state_name, presence: true

  def project_id
    Project::ProjectId.new(project_id_str)
  end

  def feature_id
    Feature::FeatureId.new(feature_id_str)
  end

  def phase
    Project::Phase.new(stage_phase_name)
  end

  def state
    return Project::State::None.new if stage_state_name.blank?
    Project::State.new(stage_state_name)
  end

  def current_stage
    Kanban::Stage.new(phase, state)
  end

  def execute(service)
    service.forward_card(project_id, feature_id, current_stage)
  rescue Kanban::WipLimitReached
    errors.add(:base, 'WIP制限です。')
    false
  else
    true
  end
end
