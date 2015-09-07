class FeatureRecord < ActiveRecord::Base
  has_one :shipped_feature_record

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
