class RemovePhaseSpecCommand
  include ActiveModel::Model
  include DomainObjectConversion

  attr_accessor :project_id_str, :phase_name

  validates :project_id_str, presence: true
  validates :phase_name, presence: true

  def execute(service)
    return false unless valid?
    service.remove_phase_spec(project_id, phase)
  rescue Activity::NeedPhaseSpec
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
