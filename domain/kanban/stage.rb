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

    def pull_card(feature_id, from, to, rule)
      raise Project::OutOfWorkflow unless rule.valid_positions_for_pull?(from, to)
      raise CardNotFound unless card = get_card_from(from, feature_id)
      raise WipLimitReached unless rule.can_put_card?(to.phase, card_count(to.phase))

      card.locate_to(to, self)
    end

    def push_card(feature_id, from, to, rule)
      raise Project::OutOfWorkflow unless rule.valid_positions_for_push?(from, to)
      raise CardNotFound unless card = get_card_from(from, feature_id)

      card.locate_to(to, self)
    end

    def get_card_from(position, feature_id)
      card = retrieve_card(feature_id)
      return card if card.position == position
      nil
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
