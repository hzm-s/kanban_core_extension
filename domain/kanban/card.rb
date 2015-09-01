module Kanban
  class Card
    attr_accessor :feature_id, :position

    def self.write(feature_id)
      new.tap {|card| card.write(feature_id) }
    end

    def write(a_feature_id)
      self.feature_id = a_feature_id
    end

    def locate(a_position)
      self.position = a_position
    end

    def same_phase?(phase)
      self.position.phase == phase
    end

    def ==(other)
      if other.instance_of?(self.class)
        self.feature_id == other.feature_id
      else
        self.feature_id == other
      end
    end

    # for AR::Base

    def to_ar_params
      {
        feature_id_str: feature_id.to_s,
        position_phase: position.phase.to_s,
        position_state: position.state.to_s
      }
    end
  end
end
