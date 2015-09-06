module Kanban
  class WipLimitReached < StandardError; end

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
      board_stages.forward_card(feature_id, current_stage, rule)
    end

    def staged_card(stage)
      board_stage(stage).cards
    end

    def count_card_by_phase(phase)
      board_stages.card_count(phase)
    end

    private

      def board_stage(stage)
        board_stages.retrieve(stage)
      end
  end
end
