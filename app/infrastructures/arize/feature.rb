module Arize
  module Feature
    extend ActiveSupport::Concern

    included do
      self.table_name = 'feature_records'

      include Writers
      include Readers
    end

    module Writers

      def project_id=(a_project_id)
        self.project_id_str = a_project_id.to_s
      end

      def feature_id=(a_feature_id)
        self.feature_id_str = a_feature_id.to_s
      end

      def description=(a_description)
        self.description_summary = a_description.summary
        self.description_detail = a_description.detail
      end
    end

    module Readers

      def project_id
        ::Project::ProjectId.new(self.project_id_str)
      end

      def feature_id
        ::Feature::FeatureId.new(self.feature_id_str)
      end

      def description
        ::Feature::Description.new(
          self.description_summary,
          self.description_detail
        )
      end
    end
  end
end
