class ProjectRecord < ActiveRecord::Base
  has_many :phase_spec_records
  has_many :state_records

  class << self

    def with_workflow
      includes(:phase_spec_records, :state_records)
    end
  end

  def name
    description_name
  end

  def goal
    description_goal
  end
end
