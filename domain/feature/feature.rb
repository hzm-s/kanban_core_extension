module Feature
  class Feature < ActiveRecord::Base
    include Arize::Feature

    def plan(project_id, feature_id, description)
      self.project_id = project_id
      self.feature_id = feature_id
      self.description = description
      log_backloged
    end

    def finish_development
      return if shipped?
      log_shipped
    end

    def backlogged?
      !backlogging_log.nil?
    end

    def shipped?
      !shipping_log.nil?
    end

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
  end
end
