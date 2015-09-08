module Feature
  class Feature < ActiveRecord::Base
    include Arize::Feature

    def finish_development
      return if shipped?
      log_shipped
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
