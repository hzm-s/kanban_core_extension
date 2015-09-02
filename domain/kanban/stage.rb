module Kanban
  class CardNotFound < StandardError; end

  class Stage

    def initialize(cards = [])
      @cards = cards
    end

    def add_card(card, rule)
      position = rule.initial_position
      card_size = count_by_phase(position.phase)
      raise WipLimitReached unless rule.can_put_card?(position.phase, card_size)

      card.locate_to(position, self)
    end

    def pull_card(feature_id, from, to, rule)
      raise Project::OutOfWorkflow unless rule.valid_positions_for_pull?(from, to)
      raise CardNotFound unless card = get_card_from(from, feature_id)

      card_size = count_by_phase(to.phase)
      raise WipLimitReached unless rule.can_put_card?(to.phase, card_size)

      card.locate_to(to, self)
    end

    def push_card(feature_id, from, to, rule)
      raise Project::OutOfWorkflow unless rule.valid_positions_for_push?(from, to)
      raise CardNotFound unless card = get_card_from(from, feature_id)

      card_size = count_by_phase(to.phase)
      raise WipLimitReached unless rule.can_put_card?(to.phase, card_size)

      card.locate_to(to, self)
    end

    def get_card(feature_id)
      retrieve_card(feature_id)
    end

    def get_card_from(position, feature_id)
      card = retrieve_card(feature_id)
      return nil unless card.position == position
      card
    end

    def count_by_phase(phase)
      @cards.select {|card| card.same_phase?(phase) }.size
    end

    # for AR::Association

    def put(card_record)
      if card_record.persisted?
        card_record.save!
      else
        @cards.build(
          feature_id_str: card_record.feature_id_str,
          position_phase: card_record.position_phase,
          position_state: card_record.position_state
        )
      end
    end

    def retrieve_card(feature_id)
      @cards.find_by(feature_id_str: feature_id.to_s)
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
