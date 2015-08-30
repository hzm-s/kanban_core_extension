class FakeProjectRepository

  def initialize
    @storage = {}
  end

  def find(project_id)
    @storage[project_id.to_s]
  end

  def store(project)
    @storage.merge!(
      project.project_id.to_s => project
    )
  end
end
