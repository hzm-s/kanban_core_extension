module Kanban
  class Card < ActiveRecord::Base

    def self.write(feature_id)
      new.tap do |card|
        card.feature_id = feature_id
      end
    end

    def locate_to(a_position, stage)
      self.position = a_position
      put_to_stage(stage)
    end

    def same_phase?(phase)
      position.phase == phase
    end

    def ==(other)
      if other.instance_of?(self.class)
        self.feature_id == other.feature_id
      else
        self.feature_id == other
      end
    end

    def feature_id=(a_feature_id)
      self.feature_id_str = a_feature_id.to_s
    end

    def position=(a_position)
      self.position_phase = a_position.phase.to_s
      self.position_state = if a_position.state.none?
                              nil
                            else
                              a_position.state.to_s
                            end
    end

    def feature_id
      Project::FeatureId.new(feature_id_str)
    end

    def position
      state = if position_state.nil?
                Project::State::None.new
              else
                Project::State.new(position_state)
              end
      Position.new(Project::Phase.new(position_phase), state)
    end

    # for AR::Base

    self.table_name = 'card_records'

    def put_to_stage(stage)
      stage.put(
        feature_id_str: feature_id_str,
        position_phase: position_phase,
        position_state: position_state
      )
    end
  end
end
