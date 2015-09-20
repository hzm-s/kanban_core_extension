class AddPhaseSpecCommand
  include ActiveModel::Model
  include PositionOptionHelper

  attr_accessor :project_id_str, :phase_name, :wip_limit_count, :state_names,
                :position, :base_phase_name

  validates :project_id_str, presence: true
  validates :phase_name, presence: true
  validates :wip_limit_count, numericality: { greater_than: 0 }, allow_blank: true
  validates :state_names, transition: true

  def describe
    base = "新しいフェーズを追加"
    return base if position.blank? || base_phase_name.blank?
    "「#{base_phase_name}」の#{position_name}に新しいフェーズを追加"
  end

  def state_names
    Array(@state_names).reject {|n| n.blank? }
  end

  def project_id
    Project::ProjectId.new(project_id_str)
  end

  def transition
    Activity::Transition.from_array(state_names)
  end

  def wip_limit
    Activity::WipLimit.from_number(wip_limit_count)
  end

  def phase_spec
    Activity::PhaseSpec.new(
      Activity::Phase.new(phase_name),
      transition,
      wip_limit
    )
  end

  def position_option
    return nil if position.nil? || base_phase_name.nil?
    option_for_phase(base_phase_name)
  end

  def execute(service)
    return false unless valid?
    service.add_phase_spec(project_id, phase_spec, position_option)
  rescue Activity::DuplicatePhase
    errors.add(:base, '同じフェーズが既にあります。')
    false
  else
    true
  end
end
