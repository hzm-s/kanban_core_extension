class ForwardCardForm
  include ActiveModel::Model

  attr_accessor :project_id_str, :feature_id_str, :position_phase_name, :position_state_name

  validates :project_id_str, presence: true
  validates :feature_id_str, presence: true
  validates :position_phase_name, presence: true
  validates :position_state_name, presence: true

  def prefer(service)
  end
end
