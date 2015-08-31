module Project
  class Transition
    include Enumerable

    def self.modelize(state_records)
      new(state_records.map {|state_record| State.new(state_record.state_description) })
    end

    def initialize(states)
      @states = states
    end

    def partial?(before_state, after_state)
      before_index = @states.index(before_state)
      @states[before_index + 1] == after_state
    end

    def first
      @states.first
    end

    # ARize

    def arize(project_record, phase_description)
      @states.each.with_index(1) do |s, n|
        s.arize(project_record, phase_description, n)
      end
    end
  end

  class Transition
    class None

      def first
        State::None.new
      end

      # ARize

      def arize(project_record, phase_description)
      end
    end
  end
end
