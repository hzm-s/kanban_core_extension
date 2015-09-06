module Kanban
  class WipLimitReached < StandardError; end

  class Rule

    def initialize(workflow)
      @workflow = workflow
    end

    def next_stage(current_stage)
      current_situation = Project::Situation.new(*current_stage.to_a)
      next_situation = @workflow.next_situation(current_situation)
      Stage.new(next_situation.phase, next_situation.state)
    end

    def can_put_card?(phase, card_size)
      return true if card_size == 0
      !@workflow.reach_wip_limit?(phase, card_size)
    end

    def initial_stage
      situation = @workflow.first_situation
      Stage.new(situation.phase, situation.state)
    end
  end
end
