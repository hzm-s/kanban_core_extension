module Kanban
  module CardForwarding
    module_function

    def detect(feature_id, current_stage, rule)
      next_stage = rule.next_stage(current_stage)

      return CardRemoving.new(feature_id, current_stage, next_stage) if next_stage.complete?
      return CardPushing.new(feature_id, current_stage, next_stage) if current_stage.same_phase?(next_stage)
      CardPulling.new(feature_id, current_stage, next_stage, rule)
    end
  end
end
