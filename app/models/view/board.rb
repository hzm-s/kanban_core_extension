module View
  Board = Struct.new(:project_name, :header, :body) do
    class << self

      def build(project_id_str)
        project_with_workflow = ProjectRecord.with_workflow(project_id_str)

        new(
          project_with_workflow.description_name,
          header(project_with_workflow),
          body
        )
      end

      private

        def header(project_with_workflow)
          View::BoardHeader.build(
            project_with_workflow.phase_spec_records.to_a,
            project_with_workflow.state_records.to_a
          )
        end

        def body
          View::BoardBody.build
        end
    end

    def stage_size
      body.stage_size
    end
  end
end
