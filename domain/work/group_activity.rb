module Work
  class AlreadyWorked < StandardError; end
  class NotWork < StandardError; end

  class GroupActivity

    def initialize(phase, transition)
      @phase = phase
      @features = Hash[*transition.flat_map {|state| [state, []] }]
    end

    def add(feature, state)
      raise AlreadyWorked if @features[state].include?(feature)
      @features[state] << feature
    end

    def progress(feature, before, after)
      raise NotWork unless @features[before].include?(feature)
      @features[before].delete(feature)
      add(feature, after)
    end

    def to_h
      @features.each_with_object({}) do |(state, features), h|
        h[state.to_s] = features.map(&:to_s)
      end
    end
  end
end
