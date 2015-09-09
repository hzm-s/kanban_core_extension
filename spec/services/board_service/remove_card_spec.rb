require 'rails_helper'

describe 'pull card' do
  let(:service) do
    BoardService.new(project_repository, board_repository, development_tracker)
  end
  let(:project_repository) { ProjectRepository.new }
  let(:board_repository) { BoardRepository.new }
  let(:development_tracker) { FakeDevelopmentTracker.new }

  let(:project_id) { Project('Name', 'Goal') }
  let(:feature_id) { Feature(project_id, 'Summary', 'Detail') }

  before do
    ProjectService().specify_workflow(project_id, workflow)
  end

  context 'no state phase' do
    let(:workflow) do
      Workflow([{ phase: 'Deploy' }])
    end

    it do
      service.add_card(project_id, feature_id)
      service.forward_card(project_id, feature_id, Step('Deploy'))

      board = board_repository.find(project_id)
      expect {
        board.fetch_card(feature_id, Step('Deploy'))
      }.to raise_error(CardNotFound)
    end
  end

  context 'multi state phase' do
    let(:workflow) do
      Workflow([{ phase: 'Deploy', transition: ['Doing', 'Done'] }])
    end

    it do
      service.add_card(project_id, feature_id)
      service.forward_card(project_id, feature_id, Step('Deploy', 'Doing'))
      service.forward_card(project_id, feature_id, Step('Deploy', 'Done'))

      board = board_repository.find(project_id)
      expect {
        board.fetch_card(feature_id, Step('Deploy', 'Done'))
      }.to raise_error(CardNotFound)
    end
  end
end
