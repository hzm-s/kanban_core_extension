class RemovePhaseSpecCommand
  include ActiveModel::Model

  attr_accessor :project_id_str, :phase_name

  validates :project_id_str, presence: true
  validates :phase_name, presence: true

  def project_id
    Project::ProjectId.new(project_id_str)
  end

  def phase
    Activity::Phase.new(phase_name)
  end

  def execute(service)
    return false unless valid?
    service.remove_phase_spec(project_id, phase)
  rescue Activity::NoMorePhaseSpec
    errors.add(:base, 'フェーズが1つしかないため削除できません。')
    false
  rescue Activity::CardOnPhase
    errors.add(:base, 'フェーズにカードがあるため削除できません。')
    false
  rescue Activity::PhaseNotFound
    errors.add(:base, 'フェーズがありません。')
    false
  else
    true
  end
end
