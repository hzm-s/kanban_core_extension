module Kanban
  module CardForwarding
    module_function

    def detect(current_stage, rule)
      next_stage = rule.next_stage(current_stage)

      return CardRemoving.new(current_stage, next_stage) if next_stage.complete?

      if current_stage.same_phase?(next_stage)
        CardPushing.new(current_stage, next_stage)
      else
        CardPulling.new(current_stage, next_stage, rule)
      end
    end
  end
end
