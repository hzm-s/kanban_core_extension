module Feature
  class Feature < ActiveRecord::Base
    include Arize::Feature

    def plan(a_project_id, a_feature_id, a_number, a_description)
      self.project_id = a_project_id
      self.feature_id = a_feature_id
      self.number = a_number
      self.description = a_description
      log_backloged
    end

    def start_development
      return if wip_log
      log_wip
    end

    def finish_development
      return if shipped_log
      log_shipped
    end

    def state
      return State::Shipped if shipped_log
      return State::Wip if wip_log
      return State::Backlogged if backlogged_log
      fail 'invalid feature state'
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
