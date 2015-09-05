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

    def valid_positions_for_pull?(from_position, to_position)
      from_situation = Project::Situation.new(*from_position.to_a)
      to_situation = Project::Situation.new(*to_position.to_a)
      @workflow.correct?(from_situation, to_situation)
    end

    def valid_positions_for_push?(from_position, to_position)
      from_situation = Project::Situation.new(*from_position.to_a)
      to_situation = Project::Situation.new(*to_position.to_a)
      @workflow.correct_transition?(from_situation, to_situation)
    end

    def initial_position
      situation = @workflow.first_situation
      Position.new(situation.phase, situation.state)
    end
  end
end
