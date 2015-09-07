class ForwardCardCommand
  include ActiveModel::Model

  attr_accessor :project_id_str, :feature_id_str, :progress_phase_name, :progress_state_name

  validates :project_id_str, presence: true
  validates :feature_id_str, presence: true
  validates :progress_phase_name, presence: true
  validates :progress_state_name, presence: true

  def project_id
    Project::ProjectId.new(project_id_str)
  end

  def feature_id
    Feature::FeatureId.new(feature_id_str)
  end

  def phase
    Project::Phase.new(progress_phase_name)
  end

  def state
    Project::State.from_string(progress_state_name)
  end

  def current_progress
    Project::Progress.new(phase, state)
  end

  def execute(service)
    service.forward_card(project_id, feature_id, current_progress)
  rescue Kanban::WipLimitReached
    errors.add(:base, 'WIP制限です。')
    false
  else
    true
  end
end
