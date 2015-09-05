module Kanban
  class WipLimitReached < StandardError; end

  class Board < ActiveRecord::Base
    include Arize::Board

    def prepare(a_project_id)
      self.project_id = a_project_id
    end

    def forward_card(feature_id, current_position, rule)
      stage.forward_card(feature_id, current_position, rule)
    end

    def add_card(feature_id, rule)
      card = Card.write(feature_id)
      stage.add_card(card, rule)
    end

    def pull_card(feature_id, from, to, rule)
      stage.pull_card(feature_id, from, to, rule)
    end

    def push_card(feature_id, from, to, rule)
      stage.push_card(feature_id, from, to, rule)
    end

    def get_card(feature_id)
      stage.retrieve_card(feature_id)
    end

    def count_card_by_phase(phase)
      stage.card_count(phase)
    end
  end
end
