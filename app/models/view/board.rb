module View
  Board = Struct.new(:project_id, :project_name, :header, :body) do
    class << self

      def build(project_id)
        project_with_workflow = ProjectRecord.with_workflow(project_id)

        new(
          project_id,
          project_with_workflow.description_name,
          header(project_with_workflow),
          body(project_id)
        )
      end

      private

        def header(project_with_workflow)
          View::BoardHeader.build(
            project_with_workflow.project_id,
            project_with_workflow.phase_spec_records.to_a,
            project_with_workflow.state_records.to_a
          )
        end

        def body(project_id)
          cards = CardRecord.with_feature(project_id)
          View::BoardBody.build(project_id, cards)
        end
    end

    def step_size
      header.phase_states.size
    end
  end
end
