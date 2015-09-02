class FakeBacklogRepository

  def initialize
    @storage = {}
  end

  def find(project_id)
    @storage[project_id.to_s]
  end

  def store(backlog)
    @storage.merge!(
      backlog.project_id.to_s => backlog
    )
  end
end
