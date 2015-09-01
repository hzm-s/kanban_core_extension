require 'rails_helper'

describe 'launch project' do
  let(:service) do
    ProjectService.new(project_repository, board_service)
  end
  let(:project_repository) { ProjectRepository.new }
  let(:board_repository) { FakeBoardRepository.new }
  let(:board_service) { BoardService.new(project_repository, board_repository) }

  it do
    description = Project::Description.new('Name', 'Goal')
    project_id = service.launch(description)

    project = project_repository.find(project_id)
    expect(project).to_not be_nil
    expect(project.description).to eq(description)
  end
end
