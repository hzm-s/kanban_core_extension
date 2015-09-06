module Kanban
  class Board < ActiveRecord::Base
    include Arize::Board

    def prepare(a_project_id)
      self.project_id = a_project_id
    end

    def add_card(feature_id, action)
      action.verify(self)
      card = Card.write(feature_id)
      board_stages.put_card(card, action.next_stage)
    end

    def forward_card(feature_id, action)
      action.verify(feature_id, self)
      board_stages.forward_card(feature_id, action.from_stage, action.to_stage)
    end

    def staged_card(stage)
      board_stages.card_on_stage(stage)
    end

    def count_card_on_phase(phase)
      board_stages.count_card_on_phase(phase)
    end
  end
end
