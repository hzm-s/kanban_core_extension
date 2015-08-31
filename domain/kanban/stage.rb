module Kanban
  class Stage
    attr_reader :phase

    def initialize(phase, wip_limit, cards = {})
      @phase = phase
      @wip_limit = wip_limit
      @cards = cards
    end

    def add_card(card, state)
      @cards[card] = state
    end

    def remove_card(card)
      @cards.delete(card)
    end

    def update_card_state(card, state)
      @cards[card] = state
    end

    def reach_wip_limit?
      @wip_limit.reach?(@cards.size)
    end

    def contain?(card)
      @cards.key?(card)
    end

    def position(card)
      Position.new(@phase, @cards[card])
    end
  end
end
