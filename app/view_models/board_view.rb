class BoardView
  class << self

    def generate(project_id_str)
      project_with_workflow = ProjectRecord.with_workflow(project_id_str)
      header = BoardHeaderView.generate(project_with_workflow)
      new(header)
    end
  end

  attr_reader :header

  def initialize(header)
    @header = header
  end
end
