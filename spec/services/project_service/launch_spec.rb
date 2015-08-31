require 'rails_helper'

describe 'launch project' do
  let(:service) do
    ProjectService.new(project_repository)
  end
  let(:project_repository) { FakeProjectRepository.new }

  it do
    name = Project::Name.new('Project A')
    goal = Project::Goal.new('The goal')

    service.launch(name, goal)

    project = project_repository.find_by_name(name)
    expect(project).to_not be_nil
  end
end
