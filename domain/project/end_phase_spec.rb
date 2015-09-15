module Project
  class EndPhaseSpec

    def first_step
      Step::Complete.new
    end

    def last?
      true
    end
  end
end
