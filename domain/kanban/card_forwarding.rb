module Kanban
  module CardForwarding
    module_function

    def detect(current_stage, rule)
      next_stage = rule.next_stage(current_stage)

      return CardRemoving.new(current_stage, next_stage) if next_stage.complete?
      return CardPushing.new(current_stage, next_stage) if current_stage.same_phase?(next_stage)
      CardPulling.new(current_stage, next_stage, rule)
    end
  end
end
