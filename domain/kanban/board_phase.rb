module Kanban
  class BoardPhase

    def initialize(stage, cards)
      @stage = stage
      @cards = cards
    end

    def put_card(card)
      card.locate_to(@stage, self)
    end

    def card_size
      @cards.size
    end

    # for AR::Association

    def put(card_record)
      card_record.save!
    end
  end
end
