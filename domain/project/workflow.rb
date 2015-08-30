module Project
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
  end
end
