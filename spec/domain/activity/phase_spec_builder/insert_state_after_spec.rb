require 'rails_helper'

module Activity
  describe PhaseSpecBuilder do
    let(:project_id) { ProjectId('prj_789') }
    let(:factory) { described_class.new(project_id, current) }

    describe '#insert_state_after' do
      let(:new_phase_spec) { factory.build_phase_spec }

      context 'current Doing|Review|Done' do
        let(:current) do
          PhaseSpec(phase: 'Dev', transition: ['Doing', 'Review', 'Done'])
        end

        context 'insert after Doing' do
          it do
            factory.insert_state_after(State('KPT'), State('Doing'))
            expect(new_phase_spec).to eq(
              PhaseSpec(
                phase: 'Dev',
                transition: ['Doing', 'KPT', 'Review', 'Done']
              )
            )
          end
        end

        context 'insert after Review' do
          it do
            factory.insert_state_after(State('KPT'), State('Review'))
            expect(new_phase_spec).to eq(
              PhaseSpec(
                phase: 'Dev',
                transition: ['Doing', 'Review', 'KPT', 'Done']
              )
            )
          end
        end

        context 'insert after Done' do
          it do
            factory.insert_state_after(State('KPT'), State('Done'))
            expect(new_phase_spec).to eq(
              PhaseSpec(
                phase: 'Dev',
                transition: ['Doing', 'Review', 'Done', 'KPT']
              )
            )
          end
        end

        context 'insert Doing after Review' do
          it do
            factory.insert_state_after(State('Doing'), State('Review'))
            expect { new_phase_spec }.to raise_error(DuplicateState)
          end
        end

        context 'insert after None' do
          it do
            expect {
              factory.insert_state_after(State('KPT'), State('None'))
            }.to raise_error(StateNotFound)
          end
        end
      end
    end
  end
end
