module Kanban
  class Card

    def initialize(feature_id)
      @feature_id = feature_id
    end

    def to_s
      @feature_id.to_s
    end

    def eql?(other)
      self == other
    end

    def hash
      to_s.hash
    end

    def ==(other)
      other.instance_of?(self.class) &&
        self == other
    end
  end
end
