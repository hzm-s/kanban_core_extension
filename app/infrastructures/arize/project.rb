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
          record_transition(phase_spec)
        end
      end

      def record_transition(phase_spec)
        return unless phase_spec.transit?
        phase_spec.transition.to_a.each.with_index(1) do |state, order|
          state_records.build(
            order: order,
            phase_description: phase_spec.phase.to_s,
            state_description: state.to_s
          )
        end
      end
    end

    module WorkflowBuilder

      def build_workflow
        ::Project::Workflow.new(
          phase_spec_records.map do |phase_spec_record|
            build_phase_spec(
              phase_spec_record,
              state_records.where(phase_description: phase_spec_record.phase_description)
            )
          end
        )
      end

      def build_phase_spec(phase_spec_record, state_records)
        ::Project::PhaseSpec.new(
          ::Project::Phase.new(phase_spec_record.phase_description),
          build_transition(state_records),
          build_wip_limit(phase_spec_record)
        )
      end

      def build_transition(state_records)
        return ::Project::Transition::None.new if state_records.empty?
        ::Project::Transition.new(
          state_records.map {|r| ::Project::State.new(r.state_description) }
        )
      end

      def build_wip_limit(phase_spec_record)
        return ::Project::WipLimit::None.new if phase_spec_record.wip_limit_count.nil?
        ::Project::WipLimit.new(phase_spec_record.wip_limit_count)
      end
    end
  end
end
