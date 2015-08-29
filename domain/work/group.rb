module Work
  class WipLimitReached < StandardError; end

  class Group
    attr_reader :project_id, :phase, :work_list

    def initialize(project_id, phase, wip_limit, transition, work_list)
      @project_id = project_id
      @phase = phase
      @wip_limit = wip_limit
      @transition = transition
      @work_list = work_list
    end

    def relay_from(before_group, feature)
      raise WipLimitReached if @wip_limit.reach?(@work_list.size + 1)

      before_group.finish_work(feature)
      start_work(feature)
    end

    protected

      def finish_work(feature)
        work = Work.new(feature, @transition.last)
        @work_list = @work_list.remove(work)
      end

    private

      def start_work(feature)
        work = Work.new(feature, @transition.first)
        @work_list = @work_list.add(work)
      end
  end
end
