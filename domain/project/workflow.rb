module Project
  class OutOfWorkflow < StandardError; end

  class Workflow

    def initialize(phase_specs)
      @phase_specs = phase_specs
    end

    def build_board_with(board_builder)
      @phase_specs.each do |phase_spec|
        board_builder.add_stage(phase_spec)
      end
      board_builder.board
    end

    def first_situation
      @phase_specs.first.first_situation
    end

    def correct_transition?(before, after)
      return false unless before.same_phase?(after)
      retrieve(before.phase).correct_transition?(before, after)
    end

    def correct?(before, after)
      return false if before.same_phase?(after)
      @phase_specs[index(before.phase) + 1].phase == after.phase
    end

    private

      def retrieve(phase)
        @phase_specs.detect {|ps| ps.phase == phase }
      end

      def index(phase)
        @phase_specs.index {|ps| ps.phase == phase }
      end
  end
end
