require 'rails_helper'

module Kanban
  describe Rule do
    describe '#next_step' do
      subject do
        rule.next_step(current_step)
      end

      let(:rule) { described_class.new(workflow) }
      let(:workflow) do
        Workflow([
          { phase: 'Todo', wip_limit: 2 },
          { phase: 'Dev', transition: ['Doing', 'Review', 'Done'], wip_limit: 2 },
          { phase: 'QA', wip_limit: 1 },
          { phase: 'Deploy', transition: ['Doing', 'Done'] }
        ])
      end

      context 'Todo' do
        let(:current_step) { Step('Todo') }
        it { is_expected.to eq(Step('Dev', 'Doing')) }
      end

      context 'Dev:Doing' do
        let(:current_step) { Step('Dev', 'Doing') }
        it { is_expected.to eq(Step('Dev', 'Review')) }
      end

      context 'Dev:Review' do
        let(:current_step) { Step('Dev', 'Review') }
        it { is_expected.to eq(Step('Dev', 'Done')) }
      end

      context 'Dev:Done' do
        let(:current_step) { Step('Dev', 'Done') }
        it { is_expected.to eq(Step('QA')) }
      end

      context 'QA' do
        let(:current_step) { Step('QA') }
        it { is_expected.to eq(Step('Deploy', 'Doing')) }
      end

      context 'Deploy:Doing' do
        let(:current_step) { Step('Deploy', 'Doing') }
        it { is_expected.to eq(Step('Deploy', 'Done')) }
      end

      context 'Deploy:Done' do
        let(:current_step) { Step('Deploy', 'Done') }
        it { is_expected.to eq(Project::Step::Complete.new) }
      end
    end
  end
end
