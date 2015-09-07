module Kanban
  module CardForwarding
    module_function

    def detect(current_stage, rule)
      next_stage = rule.next_stage(current_stage)

      return Remove.new(current_stage, next_stage) if next_stage.complete?

      if current_stage.same_phase?(next_stage)
        Push.new(current_stage, next_stage)
      else
        Pull.new(current_stage, next_stage, rule)
      end
    end

    class Remove
      attr_reader :from_stage, :to_stage

      def initialize(from_stage, to_stage)
        @from_stage = from_stage
        @to_stage = to_stage
      end

      def verify(feature_id, board)
        # nothing to do
      end
    end

    class Pull
      attr_reader :from_stage, :to_stage

      def initialize(from_stage, to_stage, rule)
        @from_stage = from_stage
        @to_stage = to_stage
        @rule = rule
      end

      def verify(feature_id, board)
        to_phase_cards = board.count_card_on_phase(@to_stage.phase)
        raise WipLimitReached unless @rule.can_put_card?(@to_stage.phase, to_phase_cards)
      end
    end

    class Push
      attr_reader :from_stage, :to_stage

      def initialize(from_stage, to_stage)
        @from_stage = from_stage
        @to_stage = to_stage
      end

      def verify(feature_id, board)
        # nothing to do
      end
    end
  end
end
