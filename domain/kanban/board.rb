module Kanban
  class WipLimitReached < StandardError; end

  class Board
    attr_reader :project_id

    def initialize(project_id, stages)
      @project_id = project_id
      @stages = stages
    end

    def add_card(card, locator)
      position = locator.initial_position
      raise WipLimitReached if @stages.reach_wip_limit?(position)
      @stages.add_card(card, position)
    end

    def position(card)
      @stages.position(card)
    end
  end
end
