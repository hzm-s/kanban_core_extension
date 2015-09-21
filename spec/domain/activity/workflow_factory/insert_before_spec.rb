require 'rails_helper'

module Activity
  describe WorkflowFactory do
    describe '#insert_before' do
      context 'NO current workflow' do
        context 'insert before NOT exists phase' do
          it do
            factory = described_class.new
            expect {
              factory.insert_before(
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
        let(:current) do
          Workflow([{ phase: 'Head' }, { phase: 'Body' }, { phase: 'Tail' }])
        end

        context 'insert before Head' do
          it do
            factory = described_class.new(current)
            factory.insert_before(
              Phase('New'),
              Transition(),
              WipLimit(),
              Phase('Head')
            )
            expect(factory.build_workflow).to eq(
              Workflow([
                { phase: 'New' }, { phase: 'Head' }, { phase: 'Body' }, { phase: 'Tail' }
              ])
            )
          end
        end

        context 'insert before Body' do
          it do
            factory = described_class.new(current)
            factory.insert_before(
              Phase('New'),
              Transition(),
              WipLimit(),
              Phase('Body')
            )
            expect(factory.build_workflow).to eq(
              Workflow([
                { phase: 'Head' }, { phase: 'New' }, { phase: 'Body' }, { phase: 'Tail' }
              ])
            )
          end
        end

        context 'insert before Tail' do
          it do
            factory = described_class.new(current)
            factory.insert_before(
              Phase('New'),
              Transition(),
              WipLimit(),
              Phase('Tail')
            )
            expect(factory.build_workflow).to eq(
              Workflow([
                { phase: 'Head' }, { phase: 'Body' }, { phase: 'New' }, { phase: 'Tail' }
              ])
            )
          end
        end

        context 'insert Body' do
          it do
            factory = described_class.new(current)
            expect {
              factory.insert_before(
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
