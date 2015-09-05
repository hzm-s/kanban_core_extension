require 'rails_helper'

module Kanban
  describe Rule do
    describe '#next_position' do
      subject do
        rule.next_position(current_position)
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
        let(:current_position) { Position('Todo', nil) }
        it { is_expected.to eq(Position('Dev', 'Doing')) }
      end

      context 'Dev:Doing' do
        let(:current_position) { Position('Dev', 'Doing') }
        it { is_expected.to eq(Position('Dev', 'Review')) }
      end

      context 'Dev:Review' do
        let(:current_position) { Position('Dev', 'Review') }
        it { is_expected.to eq(Position('Dev', 'Done')) }
      end

      context 'Dev:Done' do
        let(:current_position) { Position('Dev', 'Done') }
        it { is_expected.to eq(Position('QA', nil)) }
      end

      context 'QA' do
        let(:current_position) { Position('QA', nil) }
        it { is_expected.to eq(Position('Deploy', nil)) }
      end
    end
  end
end
