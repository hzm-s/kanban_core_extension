require 'rails_helper'

describe 'launch project' do
  let(:service) do
    ProjectService.new(project_repository)
  end
  let(:project_repository) { FakeProjectRepository.new }

  it do
    name = Project::Name.new('Project A')
    goal = Project::Goal.new('The goal')

    project_id = service.launch(name, goal)

    project = project_repository.find(project_id)
    expect(project).to_not be_nil
    expect(project.name).to eq(name)
    expect(project.goal).to eq(goal)
  end
end
