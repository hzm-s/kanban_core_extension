class AddPhaseSpecCommand
  include ActiveModel::Model
  include PositionOptionHelper

  attr_accessor :project_id_str, :phase_name, :wip_limit_count, :state_names,
                :direction, :base_phase_name

  validates :project_id_str, presence: true
  validates :phase_name, presence: true
  validates :wip_limit_count, numericality: { greater_than: 0 }, allow_blank: true
  validates :state_names, transition: true

  def describe
    position = direction.blank? ? '' : "「#{base_phase_name}」の#{direction_name}に"
    "#{position}新しいフェーズを追加"
  end

  def state_names
    Array(@state_names).reject {|n| n.blank? }
  end

  def project_id
    Project::ProjectId.new(project_id_str)
  end

  def transition
    Project::Transition.from_array(state_names)
  end

  def wip_limit
    Project::WipLimit.from_number(wip_limit_count)
  end

  def phase_spec
    Project::PhaseSpec.new(
      Project::Phase.new(phase_name),
      transition,
      wip_limit
    )
  end

  def position_option
    return nil if direction.nil? || base_phase_name.nil?
    option_for_phase(base_phase_name)
  end

  def execute(service)
    return false unless valid?
    service.add_phase_spec(project_id, phase_spec, position_option)
  end
end
