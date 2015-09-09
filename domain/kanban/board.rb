module Kanban
  class Board < ActiveRecord::Base
    include Arize::Board

    def prepare(a_project_id)
      self.project_id = a_project_id
    end

    def update_with(action)
      action.handle_board(self)
    end

    def fetch_card(feature_id, progress)
      card_map.fetch(feature_id, progress)
    end

    def put_card(card, progress)
      card.locate_to(progress, card_map)
    end

    def remove_card(card)
      card_map.remove(card)
    end

    def count_card(phase)
      card_map.count_card_by_phase(phase)
    end
  end
end
