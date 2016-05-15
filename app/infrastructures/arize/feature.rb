module Arize
  module Feature
    extend ActiveSupport::Concern

    included do
      self.table_name = 'feature_records'

      has_one :backlogged_feature_record, foreign_key: 'feature_record_id', dependent: :destroy
      has_one :wip_feature_record, foreign_key: 'feature_record_id', dependent: :destroy
      has_one :shipped_feature_record, foreign_key: 'feature_record_id', dependent: :destroy

      attribute :project_id, :project_id

      include Writers
      include Readers
    end

    module Writers

      def feature_id=(a_feature_id)
        self.feature_id_str = a_feature_id.to_s
      end

      def description=(a_description)
        self.description_summary = a_description.summary
        self.description_detail = a_description.detail
      end

      def log_backloged
        build_backlogged_feature_record(backlogged_at: Time.current)
      end

      def log_wip
        build_wip_feature_record(started_at: Time.current)
      end

      def log_shipped
        build_shipped_feature_record(shipped_at: Time.current)
      end
    end

    module Readers

      def feature_id
        ::Feature::FeatureId.new(self.feature_id_str)
      end

      def description
        ::Feature::Description.new(
          self.description_summary,
          self.description_detail
        )
      end

      def backlogged_log
        backlogged_feature_record
      end

      def wip_log
        wip_feature_record
      end

      def shipped_log
        shipped_feature_record
      end
    end
  end
end
