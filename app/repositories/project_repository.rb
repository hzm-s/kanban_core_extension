class ProjectRepository

  def find(project_id)
    ::Project::Project
      .includes(:phase_spec_records, :state_records)
      .find_by(project_id: project_id)
  end

  def store(project)
    project.save!
  end
end
