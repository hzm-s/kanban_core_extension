module Kanban
  class Board < ActiveRecord::Base
    include Arize::Board

    def prepare(a_project_id)
      self.project_id = a_project_id
    end

    def update_with(action)
      action.handle_board(self)
    end

    def fetch_card(feature_id, stage)
      board_stages.fetch_card(feature_id, stage)
    end

    def put_card(card, stage)
      board_stages.put_card(card, stage)
    end

    def remove_card(card)
      board_stages.remove(card)
    end

    def count_card_on_phase(phase)
      board_stages.count_card_on_phase(phase)
    end
  end
end
