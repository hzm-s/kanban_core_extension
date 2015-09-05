module Kanban
  class Rule

    def initialize(workflow)
      @workflow = workflow
    end

    def next_position(current_position)
      current_situation = Project::Situation.new(*current_position.to_a)
      next_situation = @workflow.next_situation(current_situation)
      Position.new(next_situation.phase, next_situation.state)
    end

    def can_put_card?(phase, card_size)
      return true if card_size == 0
      !@workflow.reach_wip_limit?(phase, card_size)
    end

    def initial_position
      situation = @workflow.first_situation
      Position.new(situation.phase, situation.state)
    end
  end
end
