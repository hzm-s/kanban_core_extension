class FakeProjectRepository

  def initialize
    @storage = {}
  end

  def find(project_id)
    @storage[project_id.to_s]
  end

  def find_by_name(name)
    @storage.values.detect do |project|
      project.name == name
    end
  end

  def store(project)
    @storage.merge!(
      project.project_id.to_s => project
    )
  end
end
