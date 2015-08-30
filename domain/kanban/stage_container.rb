module Kanban
  class StageContainer

    def initialize(stages)
      @container = stages.each_with_object({}) do |stage, c|
        c[stage.phase] = stage
      end
    end

    def add_card(card, position)
      @container[position.phase].add_card(card, position.state)
    end

    def pull_card(card, before, after)
      @container[before.phase].remove_card(card)
      raise WipLimitReached if reach_wip_limit?(after)
      add_card(card, after)
    end

    def reach_wip_limit?(position)
      @container[position.phase].reach_wip_limit?
    end

    def position(card)
      stage = @container.values.detect do |stage|
        stage.contain?(card)
      end
      stage.position(card)
    end
  end
end
