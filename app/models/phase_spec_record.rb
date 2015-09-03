class PhaseSpecRecord < ActiveRecord::Base
  belongs_to :project_record
  delegate :state_records, to: :project_record

  def states
    states_records
  end
end
