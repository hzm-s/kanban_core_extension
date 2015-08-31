class ProjectRepository

  def find(project_id)
    ::Project::Project.find_by(project_id_str: project_id.to_s)
  end

  def store(project)
    project.save!
  end
end
