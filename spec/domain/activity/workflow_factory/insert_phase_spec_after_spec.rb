require 'rails_helper'

module Activity
  describe WorkflowBuilder do
    describe '#insert_phase_spec_after' do
      let(:new_workflow) { factory.build_workflow }

      context 'NO current workflow' do
        let(:factory) { described_class.new }

        context 'insert after NOT exists phase' do
          it do
            expect {
              factory.insert_phase_spec_after(
                PhaseSpec(phase: 'Next', transition: nil, wip_limit: nil),
                Phase('None')
              )
            }.to raise_error(Activity::PhaseNotFound)
          end
        end
      end

      context 'current workflow = Head | Body | Tail' do
        let(:factory) { described_class.new(current) }

        let(:current) do
          Workflow([{ phase: 'Head' }, { phase: 'Body' }, { phase: 'Tail' }])
        end

        context 'insert after Head' do
          it do
            factory.insert_phase_spec_after(
              PhaseSpec(phase: 'New', transition: nil, wip_limit: nil),
              Phase('Head')
            )
            expect(new_workflow).to eq(
              Workflow([
                { phase: 'Head' }, { phase: 'New' }, { phase: 'Body' }, { phase: 'Tail' }
              ])
            )
          end
        end

        context 'insert after Body' do
          it do
            factory.insert_phase_spec_after(
              PhaseSpec(phase: 'New', transition: nil, wip_limit: nil),
              Phase('Body')
            )
            expect(new_workflow).to eq(
              Workflow([
                { phase: 'Head' }, { phase: 'Body' }, { phase: 'New' }, { phase: 'Tail' }
              ])
            )
          end
        end

        context 'insert after Tail' do
          it do
            factory.insert_phase_spec_after(
              PhaseSpec(phase: 'New', transition: nil, wip_limit: nil),
              Phase('Tail')
            )
            expect(new_workflow).to eq(
              Workflow([
                { phase: 'Head' }, { phase: 'Body' }, { phase: 'Tail' }, { phase: 'New' }
              ])
            )
          end
        end

        context 'insert Body' do
          it do
            factory.insert_phase_spec_after(
              PhaseSpec(phase: 'Body', transition: nil, wip_limit: nil),
              Phase('Head')
            )
            expect { new_workflow }.to raise_error(Activity::DuplicatePhase)
          end
        end
      end
    end
  end
end
