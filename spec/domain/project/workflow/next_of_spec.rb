require 'rails_helper'

module Project
  describe Workflow do
    let(:workflow) do
      Workflow([{ phase: 'Todo' }, { phase: 'Dev' }, { phase: 'QA' }])
    end

    describe '#next_of' do
      subject do
        workflow.next_of(current_phase_spec)
      end

      let(:current_phase_spec) { workflow.spec(current_phase) }
      let(:next_phase_spec) { workflow.spec(next_phase) }

      context 'current Todo' do
        let(:current_phase) { Phase('Todo') }
        let(:next_phase) { Phase('Dev') }
        it { is_expected.to eq(next_phase_spec) }
      end

      context 'current Dev' do
        let(:current_phase) { Phase('Dev') }
        let(:next_phase) { Phase('QA') }
        it { is_expected.to eq(next_phase_spec) }
      end

      context 'current QA' do
        let(:current_phase) { Phase('QA') }
        it { is_expected.to eq(EndPhaseSpec.new) }
      end

      context 'current NOT exist' do
        let(:current_phase) { Phase('NONE') }
        it { expect { subject }.to raise_error(PhaseNotFound) }
      end
    end
  end
end
