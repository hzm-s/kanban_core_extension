require 'rails_helper'

module Activity
  describe WorkflowFactory do
    describe '#insert_phase_spec_before' do
      let(:new_workflow) { factory.build_workflow }

      context 'NO current workflow' do
        let(:factory) { described_class.new }

        context 'insert before NOT exists phase' do
          it do
            expect {
              factory.insert_phase_spec_before(
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

        context 'insert before Head' do
          it do
            factory.insert_phase_spec_before(
              PhaseSpec(phase: 'New', transition: nil, wipLimit: nil),
              Phase('Head')
            )
            expect(new_workflow).to eq(
              Workflow([
                { phase: 'New' }, { phase: 'Head' }, { phase: 'Body' }, { phase: 'Tail' }
              ])
            )
          end
        end

        context 'insert before Body' do
          it do
            factory.insert_phase_spec_before(
              PhaseSpec(phase: 'New', transition: nil, wipLimit: nil),
              Phase('Body')
            )
            expect(new_workflow).to eq(
              Workflow([
                { phase: 'Head' }, { phase: 'New' }, { phase: 'Body' }, { phase: 'Tail' }
              ])
            )
          end
        end

        context 'insert before Tail' do
          it do
            factory.insert_phase_spec_before(
              PhaseSpec(phase: 'New', transition: nil, wipLimit: nil),
              Phase('Tail')
            )
            expect(new_workflow).to eq(
              Workflow([
                { phase: 'Head' }, { phase: 'Body' }, { phase: 'New' }, { phase: 'Tail' }
              ])
            )
          end
        end

        context 'insert Body' do
          it do
            factory.insert_phase_spec_before(
              PhaseSpec(phase: 'Body', transition: nil, wipLimit: nil),
              Phase('Head')
            )
            expect { new_workflow }.to raise_error(Activity::DuplicatePhase)
          end
        end
      end
    end
  end
end
