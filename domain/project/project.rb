module Project
  class Project < ActiveRecord::Base

    def specify_workflow(a_workflow)
      set_workflow(a_workflow)

      EventPublisher.publish(
        :workflow_specified,
        WorkflowSpecified.new(project_id, a_workflow)
      )
    end

    #
    # ARize
    #

    self.table_name = 'project_records'
    has_many :phase_spec_records, -> { order(:order) }
    has_many :state_records, -> { order(:order) }

    def project_id=(project_id)
      self.project_id_str = project_id.to_s
    end

    def description=(description)
      self.description_name = description.name.to_s
      self.description_goal = description.goal.to_s
    end

    def set_workflow(a_workflow)
      a_workflow.to_a.each.with_index(1) do |phase_spec, order|
        phase_spec_records.build(
          order: order,
          phase_description: phase_spec.phase.to_s,
          wip_limit_count: phase_spec.wip_limit.to_i
        )
        if phase_spec.transit?
          phase_spec.transition.to_a.each.with_index(1) do |state, order|
            state_records.build(
              order: order,
              phase_description: phase_spec.phase.to_s,
              state_description: state.to_s
            )
          end
        end
      end
    end

    def project_id
      ProjectId.new(project_id_str)
    end

    def description
      Description.new(description_name, description_goal)
    end

    def workflow
      Workflow.new(
        phase_spec_records.map do |psr|
          state_records_for_phase = state_records.where(phase_description: psr.phase_description)
          PhaseSpec.new(
            Phase.new(psr.phase_description),
            if state_records_for_phase.any?
              Transition.new(
                state_records_for_phase.map {|sr| State.new(sr.state_description) }
              )
            else
              Transition::None.new
            end,
            if psr.wip_limit_count
              WipLimit.new(psr.wip_limit_count)
            else
              WipLimit::None.new
            end
          )
        end
      )
    end
  end
end
