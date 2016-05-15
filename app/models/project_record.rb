class ProjectRecord < ActiveRecord::Base
  has_many :phase_spec_records, -> { order(:order) }
  has_many :state_records, -> { order(:order) }

  class << self

    def with_workflow(project_id)
      eager_load(:phase_spec_records, :state_records)
        .find_by(project_id: project_id)
    end
  end

  def name
    description_name
  end

  def goal
    description_goal
  end
end
