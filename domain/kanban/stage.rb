module Kanban
  class CardNotFound < StandardError; end

  class Stage

    def initialize(cards = [])
      @cards = cards
    end

    def add_card(card, rule)
      to = rule.initial_position
      raise WipLimitReached unless rule.can_put_card?(to.phase, card_count(to.phase))

      card.locate_to(to, self)
    end

    def forward_card(feature_id, current_position, rule)
      card = retrieve_card(feature_id)
      raise CardNotFound unless card.locate?(current_position)

      next_position = rule.next_position(card.position)
      if current_position.same_phase?(next_position)
        push_card(card, next_position)
      else
        pull_card(card, next_position, rule)
      end
    end

    def push_card(card, to)
      card.locate_to(to, self)
    end

    def pull_card(card, to, rule)
      raise WipLimitReached unless rule.can_put_card?(to.phase, card_count(to.phase))
      card.locate_to(to, self)
    end

    def card_count(phase)
      count_card_by_phase(phase.to_s)
    end

    # for AR::Association

    def put(card_record)
      if card_record.persisted?
        card_record.save!
      else
        @cards.build(
          feature_id_str: card_record.feature_id_str,
          position_phase_name: card_record.position_phase_name,
          position_state_name: card_record.position_state_name
        )
      end
    end

    def count_card_by_phase(phase_name)
      @cards.where(position_phase_name: phase_name).count
    end

    def retrieve_card(feature_id)
      @cards.find_by(feature_id_str: feature_id.to_s)
    end
  end
end
