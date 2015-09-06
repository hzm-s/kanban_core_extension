module Kanban
  class CardNotFound < StandardError; end
  class WipLimitReached < StandardError; end

  class BoardStage
    attr_reader :cards

    def initialize(stage, cards)
      @stage = stage
      @cards = cards
    end

    def add_card(card, rule)
      raise WipLimitReached unless rule.can_put_card?(@stage.phase, @cards.size)
      card.locate_to(@stage, self)
    end

    def forward_card(feature_id, to, rule)
      raise CardNotFound unless contain?(feature_id)
      card = @cards.find_by(feature_id_str: feature_id.to_s)
      to.pull_card(card, rule)
    end

    def pull_card(card, rule)
      raise WipLimitReached unless rule.can_put_card?(@stage.phase, @cards.size)
      card.locate_to(@stage, self)
    end

    # for AR::Association

    def put(card_record)
      if card_record.persisted?
        card_record.save!
      else
        @cards.build(
          feature_id_str: card_record.feature_id_str,
          stage_phase_name: card_record.stage_phase_name,
          stage_state_name: card_record.stage_state_name
        )
      end
    end

    def contain?(feature_id)
      @cards.exists?(feature_id_str: feature_id.to_s)
    end
  end
end
