class FeatureRecord < ActiveRecord::Base
  has_one :backlogged_feature_record, dependent: :destroy
  has_one :wip_feature_record, dependent: :destroy
  has_one :shipped_feature_record, dependent: :destroy

  class << self

    def result(project_id_str)
      includes(
        :backlogged_feature_record,
        :wip_feature_record,
        :shipped_feature_record
      )
        .where(project_id: project_id_str)
        .where.not(backlogged_feature_records: { id: nil })
        .where.not(wip_feature_records: { id: nil })
        .where.not(shipped_feature_records: { id: nil })
    end
  end

  def feature_id
    id
  end

  def summary
    description_summary
  end

  def detail
    description_detail
  end
end
