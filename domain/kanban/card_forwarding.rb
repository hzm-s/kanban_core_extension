module Kanban
  module CardForwarding
    module_function

    def detect(current_stage, rule)
      next_stage = rule.next_stage(current_stage)
      #return Push.new(current_stage) if current_stage.same_phase?(next_stage)
      Pull.new(current_stage, next_stage, rule)
    end

    class Pull

      def initialize(from_stage, to_stage, rule)
        @from_stage = from_stage
        @to_stage = to_stage
        @rule = rule
      end

      def move_card(feature_id, board)
        from = board.stage(@from_stage)
        to = board.phase(@to_stage)

        raise WipLimitReached unless @rule.can_put_card?(@to_stage.phase, to.card_size)
        to.put_card(from.fetch_card(feature_id))
      end
    end

    class Push
    end
  end
end
