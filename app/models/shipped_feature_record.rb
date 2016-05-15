class ShippedFeatureRecord < ActiveRecord::Base
  class << self

    def count(project_id)
      FeatureRecord
        .includes(:shipped_feature_record)
        .where(project_id: project_id)
        .where.not(shipped_feature_records: { id: nil })
        .count
    end
  end
end
