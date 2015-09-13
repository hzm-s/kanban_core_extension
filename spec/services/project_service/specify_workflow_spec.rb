require 'rails_helper'

describe 'specify workflow' do
  let(:service) do
    ProjectService.new(project_repository, board_repository, board_builder)
  end
  let(:project_repository) { ProjectRepository.new }
  let(:board_repository) { double(:board_repository) }
  let(:board_builder) { double(:board_builder) }

  let(:project_id) do
    service.launch(Project::Description.new('Name', 'Goal'))
  end

  it do
    workflow = Workflow([
      { phase: 'Todo', wip_limit: 10 },
      { phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: 2 },
      { phase: 'QA', wip_limit: 1 }
    ])
    service.specify_workflow(project_id, workflow)

    project = project_repository.find(project_id)
    expect(project.workflow).to eq(workflow)
  end
end
