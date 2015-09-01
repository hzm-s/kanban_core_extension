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

    def pull_card(feature_id, before, after, rule)
      stage.pull_card(feature_id, before, after, rule)
    end

    def push_card(feature_id, before, after, rule)
      stage.push_card(feature_id, before, after, rule)
    end

    def get_card(feature_id)
      stage.get_card(feature_id)
    end

    # for AR::Base

    has_many :card_records

    def project_id=(project_id)
      self.project_id_str = project_id.to_s
    end

    def project_id
      Project::ProjectId.new(self.project_id_str)
    end

    def stage
      @stage ||= Kanban::Stage.new(card_records)
    end
  end
end
