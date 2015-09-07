module Kanban
  class WipLimitReached < StandardError; end

  class Rule

    def initialize(workflow)
      @workflow = workflow
    end

    def next_progress(current_progress)
      current_situation = Project::Situation.new(*current_progress.to_a)
      next_situation = @workflow.next_situation(current_situation)
      convert_situation_to_progress(next_situation)
    end

    def can_put_card?(phase, card_size)
      return true if card_size == 0
      !@workflow.reach_wip_limit?(phase, card_size)
    end

    def first_progress
      situation = @workflow.first_situation
      convert_situation_to_progress(@workflow.first_situation)
    end

    private

      def convert_situation_to_progress(situation)
        return Progress::Complete.new if situation.complete?
        Progress.new(situation.phase, situation.state)
      end
  end
end
