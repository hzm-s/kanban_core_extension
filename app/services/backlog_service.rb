class BacklogService

  def initialize(backlog_repository)
    @backlog_repository = backlog_repository
  end

  def add_feature(project_id, description)
    backlog = @backlog_repository.find(project_id)

    feature = backlog.add_feature(description)
    @backlog_repository.store(backlog)

    feature.feature_id
  end
end
