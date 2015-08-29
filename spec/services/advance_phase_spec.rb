require 'rails_helper'

describe 'advance phase' do
  include GroupCreator

  let(:service) do
    FeatureService.new(group_repository)
  end
  let(:group_repository) { FakeGroupRepository.new }

  before do
    group_repository.store(before_group)
    group_repository.store(after_group)
  end

  let(:project_id) { 'prj_1' }

  let(:feature_id) { FeatureId('feat_123') }

  context 'after group can start new work' do
    let(:before_group) do
      Group(
        project_id: project_id,
        phase: 'Todo',
        wip_limit: nil,
        transition: nil,
        work_list: [Work(feature_id, State(nil))]
      )
    end

    let(:after_group) do
      Group(
        project_id: project_id,
        phase: 'Dev',
        wip_limit: 2,
        transition: %w(Doing Review Done),
        work_list: []
      )
    end

    it do
      before_phase = Phase('Todo')
      after_phase = Phase('Dev')

      service.advance_phase(project_id, feature_id, before_phase, after_phase)

      before_group = group_repository.find(project_id, before_phase)
      after_group = group_repository.find(project_id, after_phase)
      expect(before_group.work_list).to be_empty
      expect(after_group.work_list).to eq(
        WorkList([Work(feature_id, State('Doing'))])
      )
    end
  end

  context 'after group reaches wip limit' do
    let(:before_group) do
      Group(
        project_id: project_id,
        phase: 'Todo',
        wip_limit: nil,
        transition: nil,
        work_list: [Work(feature_id, State(nil))]
      )
    end

    let(:after_group) do
      Group(
        project_id: project_id,
        phase: 'Dev',
        wip_limit: 2,
        transition: %w(Doing Review Done),
        work_list: [
          Work(FeatureId('other1'), State('Review')),
          Work(FeatureId('other2'), State('Done')),
        ]
      )
    end

    it do
      before_phase = Phase('Todo')
      after_phase = Phase('Dev')

      expect {
        service.advance_phase(project_id, feature_id, before_phase, after_phase)
      }.to raise_error(Work::WipLimitReached)
    end
  end
end
