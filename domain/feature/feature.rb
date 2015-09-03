module Feature
  class Feature < ActiveRecord::Base

    def eql?(other)
      self == other
    end

    def ==(other)
      if other.instance_of?(self.class)
        self.feature_id == other.feature_id
      else
        self.feature_id == other
      end
    end

    ### for AR

    self.table_name = 'feature_records'

    def project_id=(a_project_id)
      self.project_id_str = a_project_id.to_s
    end

    def feature_id=(a_feature_id)
      self.feature_id_str = a_feature_id.to_s
    end

    def description=(a_description)
      self.description_summary = a_description.summary
      self.description_detail = a_description.detail
    end
  end
end
