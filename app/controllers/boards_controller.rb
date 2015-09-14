class BoardsController < ApplicationController
  layout 'board'

  def show
    @stats = View::Stats.build(params[:project_id_str], [:backlogs, :ships])
    @board = View::Board.build(params[:project_id_str])
    if @board.header.phases.any?
      render :show
    else
      redirect_to new_workflow_url(project_id_str: params[:project_id_str])
    end
  end
end
