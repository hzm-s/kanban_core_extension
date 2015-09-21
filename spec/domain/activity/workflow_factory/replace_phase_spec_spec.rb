require 'rails_helper'

module Activity
  describe WorkflowBuilder do
    let(:factory) { described_class.new(current) }
    let(:new_workflow) { factory.build_workflow }

    describe '#replace_phase_spec' do
      context 'current = Next|Dev|QA' do
        let(:current) do
          Workflow([{ phase: 'Next' }, { phase: 'Dev' }, { phase: 'QA' }])
        end

        context 'replace Next' do
          it do
            factory.replace_phase_spec(
              PhaseSpec(
                phase: 'Analyze',
                transition: ['Doing', 'Done'],
                wip_limit: 2,
              ),
              Phase('Next')
            )
            expect(new_workflow).to eq(
              Workflow([
                { phase: 'Analyze', transition: ['Doing', 'Done'], wip_limit: 2 },
                { phase: 'Dev' },
                { phase: 'QA' }
              ])
            )
          end
        end

        context 'replace None' do
          it do
            expect {
              factory.replace_phase_spec(
                PhaseSpec(
                  phase: 'Analyze',
                  transition: ['Doing', 'Done'],
                  wip_limit: 2,
                ),
                Phase('None')
              )
            }.to raise_error(PhaseNotFound)
          end
        end
      end
    end
  end
end
