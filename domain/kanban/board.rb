module Kanban
  class WipLimitReached < StandardError; end

  class Board < ActiveRecord::Base
    include Arize::Board

    #attr_reader :project_id

    #def initialize(project_id, stages)
    #  @project_id = project_id
    #  @stages = stages
    #end

    def add_card(card, locator)
      @stages.add_card(card, locator.initial_position)
    end

    def pull_card(card, before, after, locator)
      raise Project::OutOfWorkflow unless locator.valid_positions_for_pull?(before, after)
      @stages.pull_card(card, before, after)
    end

    def push_card(card, before, after, locator)
      raise Project::OutOfWorkflow unless locator.valid_positions_for_push?(before, after)
      @stages.push_card(card, before, after)
    end

    def position(card)
      @stages.position(card)
    end

    # for AR::Base

    def project_id=(project_id)
      self.project_id_str = project_id.to_s
    end

    def stages=(stages)
      stages.to_a.each do |stage|
        stage_records.build(
          phase_description: stage.phase.to_s,
          wip_limit_count: stage.wip_limit.to_i,
        )
      end
    end
  end
end
