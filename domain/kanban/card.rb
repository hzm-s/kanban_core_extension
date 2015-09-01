module Kanban
  class Card < ActiveRecord::Base
    attr_accessor :feature_id

    def self.write(feature_id)
      new.tap {|card| card.write(feature_id) }
    end

    def write(a_feature_id)
      self.feature_id = a_feature_id
    end

    def locate_to(a_position, stage)
      self.position_phase = a_position.phase.to_s
      self.position_state = a_position.state.to_s
      put_to_stage(stage)
    end

    def same_phase?(phase)
      position.phase == phase
    end

    def position
      Position.new(Project::Phase.new(position_phase), Project::State.new(position_state))
    end

    def ==(other)
      if other.instance_of?(self.class)
        self.feature_id == other.feature_id
      else
        self.feature_id == other
      end
    end

    # for AR::Base

    self.table_name = 'card_records'

    def put_to_stage(stage)
      stage.put(
        feature_id_str: feature_id.to_s,
        position_phase: position.phase,
        position_state: position.state
      )
    end
  end
end
