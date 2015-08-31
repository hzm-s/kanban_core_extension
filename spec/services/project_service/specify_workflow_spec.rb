require 'rails_helper'

__END__
describe 'specify workflow' do
  let(:service) do
    ProjectService.new(project_repository)
  end
  let(:project_repository) { FakeProjectRepository.new }

  let(:project) do
    service.launch(
      Project::Name.new('Project A'),
      Project::Goal.new('The goal')
    )
  end

  it do
    project = project_repository.find_by_name(name)
    expect(project).to_not be_nil
  end
end
