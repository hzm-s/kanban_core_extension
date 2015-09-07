module Kanban
  module CardForwarding
    module_function

    def detect(card, rule)
      next_progress = rule.next_progress(card.progress)

      return CardRemoving.new(card) if next_progress.complete?
      return CardPushing.new(card, next_progress) if card.progress.same_phase?(next_progress)
      CardPulling.new(card, next_progress, rule)
    end
  end
end
