require 'rails_helper'

describe LaunchProjectCommand do
  let(:service) { double(:project_service) }

  describe '#execute' do
    context 'given kickstart = "0"', 'no exception' do
      it do
        cmd = described_class.new(
          name: 'Project Name',
          goal: 'The Goal',
          kickstart: '0'
        )
        expect(service)
          .to receive(:launch)
          .with(Project::Description.new('Project Name', 'The Goal'))
        cmd.execute(service)
      end
    end

    context 'given kickstart = "1"', 'no exception' do
      it do
        cmd = described_class.new(
          name: 'Project Name',
          goal: 'The Goal',
          kickstart: '1'
        )
        expect(service)
          .to receive(:launch_with_workflow)
          .with(
            Project::Description.new('Project Name', 'The Goal'),
            KickStartWorkflow()
          )
        cmd.execute(service)
      end
    end

    context 'given name = ""' do
      it do
        cmd = described_class.new(
          name: '',
          goal: 'The Goal',
          kickstart: '1'
        )
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'given goal = ""' do
      it do
        cmd = described_class.new(
          name: 'Project Name',
          goal: '',
          kickstart: '1'
        )
        expect(cmd.execute(service)).to be_falsey
      end
    end
  end
end
