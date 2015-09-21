require 'rails_helper'

module Activity
  describe WorkflowFactory do
    describe '#insert_phase_spec_after' do
      context 'NO current workflow' do
        let(:factory) { described_class.new }

        context 'insert after NOT exists phase' do
          it do
            expect {
              factory.insert_phase_spec_after(
                Phase('Next'),
                Transition(),
                WipLimit(),
                Phase('None'),
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
              Phase('New'),
              Transition(),
              WipLimit(),
              Phase('Head')
            )
            expect(factory.build_workflow).to eq(
              Workflow([
                { phase: 'Head' }, { phase: 'New' }, { phase: 'Body' }, { phase: 'Tail' }
              ])
            )
          end
        end

        context 'insert after Body' do
          it do
            factory.insert_phase_spec_after(
              Phase('New'),
              Transition(),
              WipLimit(),
              Phase('Body')
            )
            expect(factory.build_workflow).to eq(
              Workflow([
                { phase: 'Head' }, { phase: 'Body' }, { phase: 'New' }, { phase: 'Tail' }
              ])
            )
          end
        end

        context 'insert after Tail' do
          it do
            factory.insert_phase_spec_after(
              Phase('New'),
              Transition(),
              WipLimit(),
              Phase('Tail')
            )
            expect(factory.build_workflow).to eq(
              Workflow([
                { phase: 'Head' }, { phase: 'Body' }, { phase: 'Tail' }, { phase: 'New' }
              ])
            )
          end
        end

        context 'insert Body' do
          it do
            expect {
              factory.insert_phase_spec_after(
                Phase('Body'),
                Transition(),
                WipLimit(),
                Phase('Head')
              )
            }.to raise_error(Activity::DuplicatePhase)
          end
        end
      end
    end
  end
end
