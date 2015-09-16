require 'rails_helper'

describe 'add state' do
  let(:service) do
    WorkflowService.new(project_repository, board_repository)
  end
  let(:project_repository) { ProjectRepository.new }
  let(:board_repository) { FakeBoardRepository.new }

  let(:project_id) { Project('Name', 'Goal') }

  before do
    ProjectService().specify_workflow(project_id, workflow)
  end
end
