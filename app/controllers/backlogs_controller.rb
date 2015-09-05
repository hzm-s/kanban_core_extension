class BacklogsController < ApplicationController

  def show
    @can_add_to_board = board_service.can_add_card?(project_id)
    @backlog = View::Backlog.build(project_id.to_s)
  end

  private

    def project_id
      Project::ProjectId.new(params[:project_id_str])
    end

    def board_service
      BoardService.new(ProjectRepository.new, BoardRepository.new)
    end
end
