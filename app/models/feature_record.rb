class FeatureRecord < ActiveRecord::Base

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
