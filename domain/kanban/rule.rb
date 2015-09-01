module Kanban
  class Rule

    def initialize(workflow)
      @workflow = workflow
    end

    def can_put_card?(phase, card_size)
      return true if card_size == 0
      !@workflow.reach_wip_limit?(phase, card_size)
    end
  end
end
