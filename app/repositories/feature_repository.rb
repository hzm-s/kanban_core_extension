class FeatureRepository

  def find(project_id, feature_id)
    ::Feature::Feature.find_by(
      project_id_str: project_id.to_s,
      feature_id_str: feature_id.to_s
    )
  end

  def last_number(project_id)
    ::Feature::Feature
      .where(project_id_str: project_id.to_s)
      .order(id: :desc)
      .last ||
        0
  end

  def store(feature)
    feature.save!
  end
end
