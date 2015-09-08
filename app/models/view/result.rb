module View
  Result = Struct.new(:project, :shipped_features) do
    class << self

      def build(project_id_str)
        project = ProjectRecord.find_by(project_id_str: project_id_str)
        shipped_features = FeatureRecord
                             .result(project_id_str)
                             .map {|r| ShippedFeature.new(r) }
        new(project, shipped_features)
      end
    end
  end

  class ShippedFeature < SimpleDelegator

    def backlogged_at
      backlogged_feature_record.backlogged_at
    end

    def shipped_at
      shipped_feature_record.shipped_at
    end

    def lead_time
      ((shipped_at - backlogged_at) / (60 * 60)).round(1)
    end
  end
end
