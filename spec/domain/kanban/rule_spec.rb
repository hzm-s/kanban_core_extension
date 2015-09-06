require 'rails_helper'

module Kanban
  describe Rule do
    describe '#next_stage' do
      subject do
        rule.next_stage(current_stage)
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
        let(:current_stage) { Stage('Todo') }
        it { is_expected.to eq(Stage('Dev', 'Doing')) }
      end

      context 'Dev:Doing' do
        let(:current_stage) { Stage('Dev', 'Doing') }
        it { is_expected.to eq(Stage('Dev', 'Review')) }
      end

      context 'Dev:Review' do
        let(:current_stage) { Stage('Dev', 'Review') }
        it { is_expected.to eq(Stage('Dev', 'Done')) }
      end

      context 'Dev:Done' do
        let(:current_stage) { Stage('Dev', 'Done') }
        it { is_expected.to eq(Stage('QA')) }
      end

      context 'QA' do
        let(:current_stage) { Stage('QA') }
        it { is_expected.to eq(Stage('Deploy')) }
      end
    end
  end
end
