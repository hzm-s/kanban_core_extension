module Arize
  module Card
    extend ActiveSupport::Concern

    included do
      self.table_name = 'card_records'

      include Writers
      include Readers
    end

    module Writers

      def feature_id=(a_feature_id)
        self.feature_id_str = a_feature_id.to_s
      end

      def position=(a_position)
        self.position_phase = a_position.phase.to_s
        self.position_state = serialize_state(a_position.state)
      end

      def serialize_state(state)
        return nil if state.none?
        state.to_s
      end
    end

    module Readers

      def feature_id
        ::Project::FeatureId.new(feature_id_str)
      end

      def position
        Kanban::Position.new(
          build_phase(position_phase),
          build_state(position_state)
        )
      end

      def build_phase(phase)
        ::Project::Phase.new(phase)
      end

      def build_state(state)
        return ::Project::State::None.new if state.nil?
        ::Project::State.new(state)
      end
    end
  end
end
