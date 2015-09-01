module Arize
  module Project
    extend ActiveSupport::Concern

    included do
      self.table_name = 'project_records'
      has_many :phase_spec_records, -> { order(:order) }
      has_many :state_records, -> { order(:order) }

      include WorkflowRecorder
      include WorkflowBuilder
    end

    module WorkflowRecorder

      def record_workflow(a_workflow)
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
    end

    module WorkflowBuilder

      def build_workflow
        ::Project::Workflow.new(
          phase_spec_records.map do |psr|
            state_records_for_phase = state_records.where(phase_description: psr.phase_description)
            ::Project::PhaseSpec.new(
              ::Project::Phase.new(psr.phase_description),
              if state_records_for_phase.any?
                ::Project::Transition.new(
                  state_records_for_phase.map {|sr| ::Project::State.new(sr.state_description) }
                )
              else
                ::Project::Transition::None.new
              end,
              if psr.wip_limit_count
                ::Project::WipLimit.new(psr.wip_limit_count)
              else
                ::Project::WipLimit::None.new
              end
            )
          end
        )
      end
    end
  end
end
