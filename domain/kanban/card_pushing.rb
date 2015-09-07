module Kanban
  class CardPushing
    attr_reader :from_stage, :to_stage

    def initialize(from_stage, to_stage)
      @from_stage = from_stage
      @to_stage = to_stage
    end

    def verify(feature_id, board)
      # nothing to do
    end
  end
end
