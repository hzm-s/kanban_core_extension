module Kanban
  class Rule

    def initialize(workflow)
      @workflow = workflow
    end

    def can_put_card?(phase, card_size)
      return true if card_size == 0
      !@workflow.reach_wip_limit?(phase, card_size)
    end

    def valid_positions_for_pull?(before_position, after_position)
      before_situation = Project::Situation.new(*before_position.to_a)
      after_situation = Project::Situation.new(*after_position.to_a)
      @workflow.correct?(before_situation, after_situation)
    end

    def valid_positions_for_push?(before_position, after_position)
      before_situation = Project::Situation.new(*before_position.to_a)
      after_situation = Project::Situation.new(*after_position.to_a)
      @workflow.correct_transition?(before_situation, after_situation)
    end

    def initial_position
      situation = @workflow.first_situation
      Position.new(situation.phase, situation.state)
    end
  end
end
