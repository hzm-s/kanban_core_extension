require 'securerandom'

module Backlog
  class Backlog
    attr_accessor :project_id, :features

    def prepare(a_project_id)
      self.project_id = a_project_id
      self.features = []
    end

    def add_feature(description)
      feature = Feature.new.tap do |feature|
        feature.feature_id = generate_feature_id
        feature.description = description
      end
      self.features << feature
      feature
    end

    def recent_feature
      self.features.last
    end

    private

      def generate_feature_id
        Backlog::FeatureId.new('feat_' + SecureRandom.uuid)
      end
  end
end
