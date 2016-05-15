class FeatureIdType < ActiveRecord::Type::String
  def serialize(value)
    feature_id = value.to_s
  end

  def deserialize(value)
    ::Feature::FeatureId.new(value)
  end
end
