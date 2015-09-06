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

      def stage=(a_stage)
        self.stage_phase_name = a_stage.phase.to_s
        self.stage_state_name = serialize_state(a_stage.state)
      end

      def serialize_state(state)
        return nil if state.none?
        state.to_s
      end
    end

    module Readers

      def feature_id
        ::Feature::FeatureId.new(feature_id_str)
      end

      def stage
        Kanban::Stage.new(
          build_phase(stage_phase_name),
          build_state(stage_state_name)
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
