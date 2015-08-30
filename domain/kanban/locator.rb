module Kanban
  class Locator

    def initialize(workflow)
      @workflow = workflow
    end

    def initial_position
      situation = @workflow.first_situation
      Position.new(situation.phase, situation.state)
    end
  end
end
