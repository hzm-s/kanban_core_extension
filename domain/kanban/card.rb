module Kanban
  class Card < ActiveRecord::Base
    include Arize::Card

    def self.write(feature_id)
      new.tap do |card|
        card.feature_id = feature_id
      end
    end

    def relocate(to)
      self.step = to
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
