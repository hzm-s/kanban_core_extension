module Kanban
  class WipLimitReached < StandardError; end

  class Board < ActiveRecord::Base
    include Arize::Board

    def prepare(project_id)
      self.project_id = project_id
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
      stage.get_card(feature_id)
    end

    # for AR::Base

    has_many :cards

    def project_id=(project_id)
      self.project_id_str = project_id.to_s
    end

    def project_id
      Project::ProjectId.new(self.project_id_str)
    end

    def stage
      @stage ||= Stage.new(cards)
    end
  end
end
