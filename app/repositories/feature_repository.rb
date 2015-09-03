class FeatureRepository

  def find(project_id, feature_id)
    ::Feature::Feature.find_by(
      project_id_str: project_id.to_s,
      feature_id_str: feature_id.to_s
    )
  end

  def store(feature)
    feature.save!
  end
end
