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
      card_map.add(Card.write(feature_id), to)
    end

    def move_card(feature_id, from, to)
      card_map.update(fetch_card(feature_id, from), to)
    end

    def remove_card(feature_id, from)
      card_map.remove(fetch_card(feature_id, from))
    end

    def fetch_card(feature_id, from)
      raise CardNotFound unless card = card_map.fetch(feature_id, from)
      card
    end

    def count_card(phase)
      card_map.count_by_phase(phase)
    end

    def any_card_on_phase?(phase)
      count_card(phase) > 0
    end

    def can_remove_step?(step)
      card_map.count_by_step(step) == 0
    end
  end
end
