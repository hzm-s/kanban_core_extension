module Kanban
  class Stage

    def initialize(cards = [])
      @cards = cards
    end

    def add_card(card, rule)
      position = rule.initial_position

      card_size = count_by_phase(position.phase)
      raise WipLimitReached unless rule.can_put_card?(position.phase, card_size)

      card.locate(position)
      @cards << card
    end

    def pull_card(feature_id, before, after, rule)
      raise Project::OutOfWorkflow unless rule.valid_positions_for_pull?(before, after)

      # TODO check card on before position
      card = get_card(feature_id)

      card_size = count_by_phase(after.phase)
      raise WipLimitReached unless rule.can_put_card?(after.phase, card_size)

      card.locate(after)
    end

    def push_card(feature_id, before, after, rule)
      raise Project::OutOfWorkflow unless rule.valid_positions_for_push?(before, after)

      # TODO check card on before position
      card = get_card(feature_id)

      card_size = count_by_phase(after.phase)
      raise WipLimitReached unless rule.can_put_card?(after.phase, card_size)

      card.locate(after)
    end

    def get_card(feature_id)
      @cards.detect {|card| card == feature_id }
    end

    def count_by_phase(phase)
      @cards.select {|card| card.same_phase?(phase) }.size
    end
  end
end

__END__
module Kanban
  class Stage
    attr_reader :phase, :wip_limit

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
