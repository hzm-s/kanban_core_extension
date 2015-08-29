require 'rails_helper'

describe 'advance phase' do
  let(:service) do
    FeatureService.new(group_repository)
  end
  let(:group_repository) { FakeGroupRepository.new }

  before do
    group_repository.store(before_group)
    group_repository.store(after_group)
  end

  let(:project_id) { 'prj_1' }

  let(:feature) { Feature::FeatureId.new('feat_123') }

  let(:before_group) do
    Work::Group.new(
      project_id,
      Work::Phase.new('Todo'),
      Work::WipLimit::None.new,
      Work::EmptyTransition.new,
      Work::WorkList.new([Work::Work.new(feature, Work::NothingState.new)])
    )
  end

  let(:after_group) do
    Work::Group.new(
      project_id,
      Work::Phase.new('Dev'),
      Work::WipLimit.new(2),
      Work::Transition.new([
        Work::State.new('Doing'), Work::State.new('Review'), Work::State.new('Done')
      ]),
      Work::WorkList.new([])
    )
  end

  it do
    before_phase = Work::Phase.new('Todo')
    after_phase = Work::Phase.new('Dev')

    service.advance_phase(project_id, feature, before_phase, after_phase)

    before_group = group_repository.find(project_id, before_phase)
    after_group = group_repository.find(project_id, after_phase)
    expect(before_group.work_list).to be_empty
    expect(after_group.work_list).to eq(
      Work::WorkList.new([Work::Work.new(feature, Work::State.new('Doing'))])
    )
  end
end
