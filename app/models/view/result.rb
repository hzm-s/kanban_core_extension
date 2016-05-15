module View
  Result = Struct.new(:project, :shipped_features) do
    class << self

      def build(project_id)
        project = ProjectRecord.find_by(project_id: project_id)
        shipped_features = FeatureRecord
                             .result(project_id)
                             .map {|r| ShippedFeature.new(r) }
        new(project, shipped_features)
      end
    end
  end

  class ShippedFeature < SimpleDelegator

    def start_develop_at
      wip_feature_record.started_at
    end

    def shipped_at
      shipped_feature_record.shipped_at
    end

    def lead_time
      ((shipped_at - start_develop_at) / (60 * 60)).round(1)
    end
  end
end
