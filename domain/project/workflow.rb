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

    def next_situation(current_situation)
      @phase_specs[index(current_situation.phase) + 1].first_situation
    end

    def correct_transition?(from, to)
      return false unless from.same_phase?(to)
      retrieve(from.phase).correct_transition?(from, to)
    end

    def correct?(from, to)
      return false if from.same_phase?(to)
      @phase_specs[index(from.phase) + 1].phase == to.phase
    end

    def reach_wip_limit?(phase, wip)
      retrieve(phase).reach_wip_limit?(wip)
    end

    def to_a
      @phase_specs
    end

    def eql?(other)
      self == other
    end

    def hash
      to_a.hash
    end

    def ==(other)
      other.instance_of?(self.class) &&
        self.to_a == other.to_a
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
