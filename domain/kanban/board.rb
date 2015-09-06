module Kanban
  class Board < ActiveRecord::Base
    include Arize::Board

    def prepare(a_project_id)
      self.project_id = a_project_id
    end

    def add_card(feature_id, rule)
      card = Card.write(feature_id)
      first_board_stage = board_stages.as_stage(rule.initial_stage)
      first_board_stage.add_card(card, rule)
    end

    def forward_card(feature_id, current_stage, rule)
      next_stage = rule.next_stage(current_stage)

      if current_stage.same_phase?(next_stage)
        from = board_stages.as_phase(current_stage)
        from.push_card(next_stage)
      else
        from = board_stages.as_stage(current_stage)
        to = board_stages.as_phase(next_stage)
        to.pull_card(from)
      end
    end

    def update_with(feature_id, card_forwarding)
      card_forwarding.move_card(feature_id, self)
    end

    def staged_card(a_stage)
      stage(a_stage).cards
    end

    def stage(a_stage)
      board_stages.as_stage(a_stage)
    end

    def phase(a_stage)
      board_stages.as_phase(a_stage)
    end
  end
end
