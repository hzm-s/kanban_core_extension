module Kanban
  module CardForwarding
    module_function

    def detect(card, rule)
      next_stage = rule.next_stage(card.stage)

      return CardRemoving.new(card) if next_stage.complete?
      return CardPushing.new(card, next_stage) if card.stage.same_phase?(next_stage)
      CardPulling.new(card, next_stage, rule)
    end
  end
end
