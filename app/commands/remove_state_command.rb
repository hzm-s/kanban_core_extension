class RemoveStateCommand
  include ActiveModel::Model
  include DomainObjectConversion

  attr_accessor :project_id_str, :phase_name, :state_name

  validates :project_id_str, presence: true
  validates :phase_name, presence: true
  validates :state_name, presence: true

  def execute(service)
    return false unless valid?
    service.remove_state(project_id, phase, state)
  rescue Activity::CardOnState
    errors.add(:base, '対象の状態にカードがあるため削除できません。')
    false
  rescue Activity::NeedMoreThanOneState
    errors.add(:base, '状態は2つ以上必要です。')
    false
  rescue Activity::PhaseNotFound
    errors.add(:base, 'フェーズが見つかりません。')
    false
  rescue Activity::StateNotFound
    errors.add(:base, '状態が見つかりません。')
    false
  else
    true
  end
end
