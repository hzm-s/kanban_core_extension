module Kanban
  class WipLimitReached < StandardError; end

  class Board# < ActiveRecord::Base
    #include Arize::Board

    #attr_reader :project_id

    #def initialize(project_id, stages)
    #  @project_id = project_id
    #  @stages = stages
    #end

    def add_card(feature_id, rule, locator)
      card = Card.write(feature_id)
      stage.add(card, locator.initial_position, rule)
    end

    def pull_card(card, before, after, locator)
      raise Project::OutOfWorkflow unless locator.valid_positions_for_pull?(before, after)
      @stages.pull_card(card, before, after)
    end

    def push_card(card, before, after, locator)
      raise Project::OutOfWorkflow unless locator.valid_positions_for_push?(before, after)
      @stages.push_card(card, before, after)
    end

    def get_card(feature_id)
      stage.get_card(feature_id)
    end

    # for AR::Base

    def project_id=(project_id)
      #self.project_id_str = project_id.to_s
      @project_id = project_id
    end

    def prepare(project_id)
      @project_id = project_id
      @stage = Kanban::Stage.new
    end

    def stage
      @stage
    end

    def stages=(stages)
      #stages.to_a.each do |stage|
      #  stage_records.build(
      #    phase_description: stage.phase.to_s,
      #    wip_limit_count: stage.wip_limit.to_i,
      #  )
      #end
      @stages = stages
    end

    def project_id
      #Project::ProjectId.new(self.project_id_str)
      @project_id
    end
  end
end
