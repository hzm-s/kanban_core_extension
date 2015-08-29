class FeatureService

  def initialize(group_repository)
    @group_repository = group_repository
  end

  def advance_phase(project_id, feature, before_phase, after_phase)
    before_group = @group_repository.find(project_id, before_phase)
    after_group = @group_repository.find(project_id, after_phase)

    after_group.relay_from(before_group, feature)

    @group_repository.store(before_group)
    @group_repository.store(after_group)
  end
end
