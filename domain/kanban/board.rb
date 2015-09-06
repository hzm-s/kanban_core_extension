module Kanban
  class WipLimitReached < StandardError; end

  class Board < ActiveRecord::Base
    include Arize::Board

    def prepare(a_project_id)
      self.project_id = a_project_id
    end

    def forward_card(feature_id, current_stage, rule)
      stage_map.forward_card(feature_id, current_stage, rule)
    end

    def add_card(feature_id, rule)
      card = Card.write(feature_id)
      stage_map.add_card(card, rule)
    end

    def pull_card(feature_id, from, to, rule)
      stage_map.pull_card(feature_id, from, to, rule)
    end

    def push_card(feature_id, from, to, rule)
      stage_map.push_card(feature_id, from, to, rule)
    end

    def get_card(feature_id)
      stage_map.retrieve_card(feature_id)
    end

    def count_card_by_phase(phase)
      stage_map.card_count(phase)
    end
  end
end
