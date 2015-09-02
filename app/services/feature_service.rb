class FeatureService

  def initialize(feature_repository)
    @feature_repository = feature_repository
  end

  def add(project_id, description)
    backlog_service = Feature::BacklogService.new(@feature_repository)

    feature = backlog_service.add_feature(project_id, description)
    @feature_repository.store(feature)

    feature.feature_id
  end
end
