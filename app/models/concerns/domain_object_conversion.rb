module DomainObjectConversion

  def project_id
    Project::ProjectId.new(project_id_str)
  end

  def feature_id
    Feature::FeatureId.new(feature_id_str)
  end

  def phase
    Activity::Phase.new(phase_name)
  end

  def state
    Activity::State.new(state_name)
  end

  def step
    Activity::Step.new(phase, state)
  end

  def wip_limit
    Activity::WipLimit.from_number(wip_limit_count.to_i)
  end
end
