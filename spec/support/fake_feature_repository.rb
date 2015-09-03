class FakeFeatureRepository

  def initialize
    @storage = {}
  end

  def find(project_id, feature_id)
    @storage[project_id.to_s][feature_id.to_s]
  end

  def store(feature)
    @storage.merge!(
      feature.project_id.to_s => {
        feature.feature_id.to_s => feature
      }
    )
  end
end
