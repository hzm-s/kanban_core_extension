module Arize
  module Project
    extend ActiveSupport::Concern

    included do
      self.table_name = 'project_records'

      has_many :phase_spec_records, { foreign_key: 'project_record_id' }, -> { order(:order) }
      has_many :state_records, { foreign_key: 'project_record_id' }, -> { order(:order) }

      attribute :project_id, :project_id

      include Writers
      include Readers
    end

    module Writers

      def description=(description)
        self.description_name = description.name.to_s
        self.description_goal = description.goal.to_s
      end

      def workflow=(a_workflow)
        phase_spec_records.each(&:destroy)
        state_records.each(&:destroy)
        make_phase_spec_records(a_workflow)
        make_state_records(a_workflow)
      end

      def make_phase_spec_records(a_workflow)
        a_workflow.to_a.each.with_index(1) do |phase_spec, order|
          phase_spec_records.build(
            project_record_id: id,
            order: order,
            phase_name: phase_spec.phase.to_s,
            wip_limit_count: phase_spec.wip_limit.to_i
          )
        end
      end

      def make_state_records(a_workflow)
        a_workflow.to_a.each do |phase_spec|
          phase_spec.transition.to_a.each.with_index(1) do |state, order|
            state_records.build(
              project_record_id: id,
              order: order,
              phase_name: phase_spec.phase.to_s,
              state_name: state.to_s
            )
          end
        end
      end
    end

    module Readers

      def description
        ::Project::Description.new(description_name, description_goal)
      end

      def workflow
        build_workflow
      end

      def build_workflow
        ::Activity::Workflow.new(
          phase_spec_records.map do |phase_spec_record|
            build_phase_spec(
              phase_spec_record,
              state_records.where(phase_name: phase_spec_record.phase_name)
            )
          end
        )
      end

      def build_phase_spec(phase_spec_record, state_records)
        ::Activity::PhaseSpec.new(
          ::Activity::Phase.new(phase_spec_record.phase_name),
          build_transition(state_records),
          build_wip_limit(phase_spec_record)
        )
      end

      def build_transition(state_records)
        return ::Activity::NoTransition.new if state_records.empty?
        ::Activity::Transition.new(
          state_records.map {|r| ::Activity::State.new(r.state_name) }
        )
      end

      def build_wip_limit(phase_spec_record)
        return ::Activity::NoWipLimit.new if phase_spec_record.wip_limit_count.nil?
        ::Activity::WipLimit.new(phase_spec_record.wip_limit_count)
      end
    end
  end
end
