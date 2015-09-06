module Kanban
  class Board < ActiveRecord::Base
    include Arize::Board

    def prepare(a_project_id)
      self.project_id = a_project_id
    end

    def add_card(feature_id, rule)
      card = Card.write(feature_id)
      board_stage(rule.initial_stage).add_card(card, rule)
    end

    def forward_card(feature_id, current_stage, rule)
      from = board_stage(current_stage)
      to = board_stage(rule.next_stage(current_stage))
      from.forward_card(feature_id, to, rule)
    end

    def staged_card(stage)
      board_stage(stage).cards
    end

    private

      def board_stage(stage)
        board_stages.retrieve(stage)
      end
  end
end
