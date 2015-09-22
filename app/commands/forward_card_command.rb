class ForwardCardCommand
  include ActiveModel::Model
  include DomainObjectConversion

  attr_accessor :project_id_str, :feature_id_str, :step_phase_name, :step_state_name

  validates :project_id_str, presence: true
  validates :feature_id_str, presence: true
  validates :step_phase_name, presence: true
  validates :step_state_name, presence: true, allow_blank: true

  alias_method :phase_name, :step_phase_name
  alias_method :state_name, :step_state_name
  alias_method :current_step, :step

  def execute(service)
    return false unless valid?

    service.forward_card(project_id, feature_id, current_step)

  rescue Activity::WipLimitReached
    errors.add(:base, 'WIP制限です。')
    false
  else
    true
  end
end
