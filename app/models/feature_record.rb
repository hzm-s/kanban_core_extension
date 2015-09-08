class FeatureRecord < ActiveRecord::Base
  has_one :backlogged_feature_record, dependent: :destroy
  has_one :card_record, foreign_key: 'feature_id_str', dependent: :destroy
  has_one :shipped_feature_record, dependent: :destroy

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
