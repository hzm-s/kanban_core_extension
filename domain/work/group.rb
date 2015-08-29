module Work
  class Group
    attr_reader :project_id, :phase, :work_list

    def initialize(project_id, phase, transition, work_list)
      @project_id = project_id
      @phase = phase
      @transition = transition
      @work_list = work_list
    end

    def start_work(feature)
      work = Work.new(feature, @transition.first)
      @work_list = @work_list.add(work)
    end

    def finish_work(feature)
      work = Work.new(feature, @transition.last)
      @work_list = @work_list.remove(work)
    end
  end
end
