class FakeGroupRepository

  def initialize
    @storage = {}
  end

  def find(project_id, phase)
    @storage[project_id.to_s][phase.to_s]
  end

  def store(object)
    @storage.deep_merge!(
      object.project_id.to_s => {
        object.phase.to_s => object
      }
    )
  end
end
