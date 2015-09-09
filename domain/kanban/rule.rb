module Kanban
  class WipLimitReached < StandardError; end

  class Rule

    def initialize(workflow)
      @workflow = workflow
    end

    def next_step(current_step)
      @workflow.next_step(current_step)
    end

    def can_put_card?(phase, card_size)
      return true if card_size == 0
      !@workflow.reach_wip_limit?(phase, card_size)
    end

    def first_step
      @workflow.first_step
    end
  end
end
