module Kanban
  class Locator

    def initialize(workflow)
      @workflow = workflow
    end

    def initial_position
      situation = @workflow.first_situation
      Position.new(situation.phase, situation.state)
    end

    def valid_positions_for_push?(before_position, after_position)
      before_situation = Project::Situation.new(*before_position.to_a)
      after_situation = Project::Situation.new(*after_position.to_a)
      @workflow.correct_transition?(before_situation, after_situation)
    end
  end
end
