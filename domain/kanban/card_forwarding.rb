module Kanban
  module CardForwarding
    module_function

    def detect(feature_id, from, rule)
      to = rule.next_progress(from)

      return CardRemoving.new(feature_id, from) if to.complete?
      return CardPushing.new(feature_id, from, to) if from.same_phase?(to)
      CardPulling.new(feature_id, from, to, rule)
    end
  end
end
