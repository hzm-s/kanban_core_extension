module Kanban
  module Actions
    module_function

    def detect(feature_id, from, workflow)
      to = workflow.next_step(from)

      return RemoveCard.new(feature_id, from) if to.complete?
      return PushCard.new(feature_id, from, to) if from.same_phase?(to)
      PullCard.new(feature_id, from, to, workflow)
    end
  end
end
