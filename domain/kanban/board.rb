module Kanban
  class Board < ActiveRecord::Base
    include Arize::Board

    def prepare(a_project_id)
      self.project_id = a_project_id
    end

    def update_by(action)
      action.handle_board(self)
    end

    def add_card(feature_id, to)
      card = Card.write(feature_id)
      put_card(card, to)

      EventPublisher.publish(:card_added, CardAdded.new(project_id, card))
    end

    def put_card(card, to)
      card.locate_to(to, card_map)
    end

    def fetch_card(feature_id, progress)
      card_map.fetch(feature_id, progress)
    end

    def remove_card(card)
      card_map.remove(card)
    end

    def count_card(phase)
      card_map.count_card_by_phase(phase)
    end
  end
end
