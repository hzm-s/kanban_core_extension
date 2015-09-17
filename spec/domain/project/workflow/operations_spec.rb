require 'rails_helper'

module Project
  describe Workflow do
    pending '#operation_for_phase' do
      it do
        workflow = Workflow(phase: 'Dev')
        expect(workflow.operations).to eq(
          Project::Operations.new([
            Project::Operations::ChangePhaseName.new,
            Project::Operations::ChangeWipLimit.new,
            Project::Operations::DisableWipLimit.new,
            Project::Operations::InsertPhaseSpecBefore.new,
            Project::Operations::InsertPhaseSpecAfter.new,
            Project::Operations::SetTransition.new,
            Project::Operations::RemovePhaseSpec.new
          ])
        )
      end
    end

    describe '#operation_for_state' do
      context 'transition = 2 states' do
        let(:workflow) { Workflow([{ phase: 'Dev', transition: ['Doing', 'Done'] }]) }

        context 'for Doing' do
          it do
            ops = workflow.operation_for_state(Phase('Dev'), State('Doing'))
            expect(ops).to eq([
              Operations::InsertStateBefore.new,
              Operations::InsertStateAfter.new
            ])
          end
        end

        context 'for Done' do
          it do
            ops = workflow.operation_for_state(Phase('Dev'), State('Done'))
            expect(ops).to eq([
              Operations::InsertStateBefore.new,
              Operations::InsertStateAfter.new
            ])
          end
        end
      end

      context 'transition = 3 states' do
        let(:workflow) do
          Workflow([{ phase: 'Dev', transition: ['Doing', 'Review', 'Done'] }])
        end

        context 'for Doing' do
          it do
            ops = workflow.operation_for_state(Phase('Dev'), State('Doing'))
            expect(ops).to eq([
              Operations::InsertStateBefore.new,
              Operations::InsertStateAfter.new,
              Operations::RemoveState.new
            ])
          end
        end
      end
    end
  end
end
