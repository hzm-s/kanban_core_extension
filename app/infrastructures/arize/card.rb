module Arize
  module Card
    extend ActiveSupport::Concern

    included do
      self.table_name = 'card_records'

      attribute :feature_id, :feature_id

      include Writers
      include Readers
    end

    module Writers

      #def feature_id=(a_feature_id)
      #  self.feature_id_str = a_feature_id.to_s
      #end

      def step=(a_step)
        self.step_phase_name = a_step.phase.to_s
        self.step_state_name = serialize_state(a_step.state)
      end

      def serialize_state(state)
        state.to_s
      end
    end

    module Readers

      #def feature_id
      #  ::Feature::FeatureId.new(feature_id_str)
      #end

      def step
        ::Project::Step.new(
          build_phase(step_phase_name),
          build_state(step_state_name)
        )
      end

      def build_phase(phase)
        ::Project::Phase.new(phase)
      end

      def build_state(state)
        ::Project::State.from_string(state)
      end
    end
  end
end
