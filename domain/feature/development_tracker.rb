module Feature
  class DevelopmentTracker

    def initialize(feature_repository)
      @feature_repository = feature_repository
    end

    def card_removed(event)
      feature = @feature_repository.find(event.project_id, event.card.feature_id)
      feature.finish_development
      @feature_repository.store(feature)
    end
  end
end
