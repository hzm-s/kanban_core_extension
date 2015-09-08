class BackloggedFeatureRecord < ActiveRecord::Base
  class << self

    def count(project_id_str)
      FeatureRecord
        .includes(
          :backlogged_feature_record,
          :card_record,
          :shipped_feature_record
        )
        .where(project_id_str: project_id_str)
        .where.not(backlogged_feature_records: { id: nil })
        .where(card_records: { feature_id_str: nil })
        .where(shipped_feature_records: { id: nil })
        .count
    end
  end
end
