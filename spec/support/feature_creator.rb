module FeatureCreator

  def Feature(project_id, summary, detail)
    description = ::Feature::Description.new(summary, detail)
    FeatureService().add(project_id, description)
  end

  def FeatureId(id_string)
    ::Feature::FeatureId.new(id_string)
  end

  def FeatureService(feature_repository: FeatureRepository.new)
    FeatureService.new(feature_repository)
  end
end
