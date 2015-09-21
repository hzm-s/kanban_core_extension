require 'rails_helper'

module Activity
  describe WorkflowFactory do
    describe '#remove_phase_spec' do
      let(:factory) { described_class.new(current) }
      let(:new_workflow) { factory.build_workflow }
      let(:board) do
        Kanban::Board.new.tap {|b| b.prepare(ProjectId('prj_789')) }
      end

      context 'no state phase' do
        let(:current) { Workflow.new([target, rest]) }

        let(:target) { PhaseSpec(phase: 'Todo') }
        let(:rest) { PhaseSpec(phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: 3) }

        context 'no card' do
          it do
            factory.remove_phase_spec(target.phase, board)
            expect(new_workflow).to eq(Workflow.new([rest]))
          end
        end

        context 'card exists' do
          before do
            board.add_card(FeatureId('feat_123'), Step('Todo'))
            board.save!
          end

          it do
            expect {
              factory.remove_phase_spec(target.phase, board)
            }.to raise_error(Activity::CardOnPhase)
          end
        end
      end

      context 'multi state phase' do
        let(:current) { Workflow.new([target, rest]) }

        let(:target) { PhaseSpec(phase: 'Analyze', transition: ['Doing', 'Done']) }
        let(:rest) { PhaseSpec(phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: 3) }

        context 'no card' do
          it do
            factory.remove_phase_spec(target.phase, board)
            expect(new_workflow).to eq(Activity::Workflow.new([rest]))
          end
        end

        context 'card exists' do
          before do
            board.add_card(FeatureId('feat_123'), Step('Analyze', 'Done'))
            board.save!
          end

          it do
            expect {
              factory.remove_phase_spec(target.phase, board)
            }.to raise_error(Activity::CardOnPhase)
          end
        end
      end

      context 'workflow has only 1 phase spec' do
        let(:current) { Workflow([{ phase: 'Dev' }]) }

        it do
          factory.remove_phase_spec(Phase('Dev'), board)
          expect { new_workflow }.to raise_error(Activity::NoMorePhaseSpec)
        end
      end
    end
  end
end
