require 'securerandom'

module Feature
  class BacklogService

    def initialize(feature_repository)
      @feature_repository = feature_repository
    end

    def add_feature(project_id, description)
      ::Feature::Feature.new.tap do |feature|
        feature.plan(
          project_id,
          generate_feature_id,
          next_number(project_id),
          description
        )
      end
    end

    private

      def generate_feature_id
        FeatureId.new('feat_' + SecureRandom.uuid)
      end

      def next_number(project_id)
        @feature_repository.last_number(project_id) + 1
      end
  end
end
