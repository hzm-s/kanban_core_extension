require 'securerandom'

module Feature
  class BacklogService

    def initialize(feature_repository)
      @feature_repository = feature_repository
    end

    def add_feature(project_id, description)
      ::Feature::Feature.new.tap do |feature|
        feature.project_id = project_id
        feature.feature_id = generate_feature_id
        feature.description = description
      end
    end

    private

      def generate_feature_id
        FeatureId.new('feat_' + SecureRandom.uuid)
      end
  end
end
