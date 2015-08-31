module Kanban
  class WipLimitReached < StandardError; end

  class Board
    attr_reader :project_id

    def initialize(project_id, stages)
      @project_id = project_id
      @stages = stages
    end

    def add_card(card, locator)
      @stages.add_card(card, locator.initial_position)
    end

    def pull_card(card, before, after, locator)
      raise Project::OutOfWorkflow unless locator.valid_positions_for_pull?(before, after)
      @stages.pull_card(card, before, after)
    end

    def push_card(card, before, after, locator)
      raise Project::OutOfWorkflow unless locator.valid_positions_for_push?(before, after)
      @stages.push_card(card, before, after)
    end

    def position(card)
      @stages.position(card)
    end
  end
end
