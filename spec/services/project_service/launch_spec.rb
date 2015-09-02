require 'rails_helper'

describe 'launch project' do
  let(:service) do
    ProjectService.new(project_repository, board_builder)
  end
  let(:project_repository) { ProjectRepository.new }
  let(:board_builder) { double(:board_builder) }

  it do
    description = Project::Description.new('Name', 'Goal')
    project_id = service.launch(description)

    project = project_repository.find(project_id)
    expect(project).to_not be_nil
    expect(project.description).to eq(description)
  end
end
