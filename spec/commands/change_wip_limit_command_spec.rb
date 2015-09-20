require 'rails_helper'

describe ChangeWipLimitCommand do
  let(:project_id) { ProjectId('prj_789') }
  let(:service) { double(:workflow_service) }

  describe '#execute' do
    context 'no exceptions' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          phase_name: 'Dev',
          wip_limit_count: 3
        )
        expect(service)
          .to receive(:change_wip_limit)
          .with(project_id, Phase('Dev'), WipLimit(3))
        cmd.execute(service)
      end
    end

    context 'given phase_name = ""' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          phase_name: '',
          wip_limit_count: 3
        )
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'given wip_limit_count = ""' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          phase_name: 'Dev',
          wip_limit_count: ''
        )
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'given wip_limit_count = "0"' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          phase_name: 'Dev',
          wip_limit_count: 0
        )
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'given wip_limit_count = "-1"' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          phase_name: 'Dev',
          wip_limit_count: -1
        )
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'given wip_limit_count = "one"' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          phase_name: 'Dev',
          wip_limit_count: 'one'
        )
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'service raises Project::UnderCurrentWip' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          phase_name: 'Dev',
          wip_limit_count: 3
        )
        allow(service).to receive(:change_wip_limit).and_raise(Project::UnderCurrentWip)
        expect(cmd.execute(service)).to be_falsey
      end
    end
  end
end
