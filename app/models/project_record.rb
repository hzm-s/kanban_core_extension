class ProjectRecord < ActiveRecord::Base
  has_many :phase_spec_records
  has_many :state_records

  class << self

    def with_workflow(project_id_str)
      includes(:phase_spec_records, :state_records)
        .find_by(project_id_str: project_id_str)
    end
  end

  def name
    description_name
  end

  def goal
    description_goal
  end
end
