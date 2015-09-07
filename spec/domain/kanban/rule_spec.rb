require 'rails_helper'

module Kanban
  describe Rule do
    describe '#next_progress' do
      subject do
        rule.next_progress(current_progress)
      end

      let(:rule) { described_class.new(workflow) }
      let(:workflow) do
        Workflow([
          { phase: 'Todo', wip_limit: 2 },
          { phase: 'Dev', transition: ['Doing', 'Review', 'Done'], wip_limit: 2 },
          { phase: 'QA', wip_limit: 1 },
          { phase: 'Deploy' }
        ])
      end

      context 'Todo' do
        let(:current_progress) { Progress('Todo') }
        it { is_expected.to eq(Progress('Dev', 'Doing')) }
      end

      context 'Dev:Doing' do
        let(:current_progress) { Progress('Dev', 'Doing') }
        it { is_expected.to eq(Progress('Dev', 'Review')) }
      end

      context 'Dev:Review' do
        let(:current_progress) { Progress('Dev', 'Review') }
        it { is_expected.to eq(Progress('Dev', 'Done')) }
      end

      context 'Dev:Done' do
        let(:current_progress) { Progress('Dev', 'Done') }
        it { is_expected.to eq(Progress('QA')) }
      end

      context 'QA' do
        let(:current_progress) { Progress('QA') }
        it { is_expected.to eq(Progress('Deploy')) }
      end

      context 'Deploy' do
        let(:current_progress) { Progress('Deploy') }
        it { is_expected.to eq(Project::Progress::Complete.new) }
      end
    end
  end
end
