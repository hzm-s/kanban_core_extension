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
      !@workflow.spec(phase).reach_wip_limit?(card_size)
    end

    def first_step
      @workflow.first_step
    end
  end
end
