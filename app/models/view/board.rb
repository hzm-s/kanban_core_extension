module View
  class Board
    class << self

      def build(project_id_str)
        new(
          header(project_id_str),
          body
        )
      end

      private

        def header(project_id_str)
          project_with_workflow = ProjectRecord.with_workflow(project_id_str)
          View::BoardHeader.build(project_with_workflow)
        end

        def body
          View::BoardBody.build
        end
    end

    attr_reader :header, :body

    def initialize(header, body)
      @header = header
      @body = body
    end

    def stage_size
      @body.stage_size
    end
  end
end
