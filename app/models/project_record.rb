class ProjectRecord < ActiveRecord::Base

  def name
    description_name
  end

  def goal
    description_goal
  end
end
