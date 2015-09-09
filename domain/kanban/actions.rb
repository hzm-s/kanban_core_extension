module Kanban
  module Actions
    module_function

    def detect(feature_id, from, rule)
      to = rule.next_step(from)

      return RemoveCard.new(feature_id, from) if to.complete?
      return PushCard.new(feature_id, from, to) if from.same_phase?(to)
      PullCard.new(feature_id, from, to, rule)
    end
  end
end
