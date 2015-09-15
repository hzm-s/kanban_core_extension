class BoardsController < ApplicationController
  layout 'board'

  def show
    @stats = View::Stats.build(params[:project_id_str], [:backlogs, :ships])
    @board = View::Board.build(params[:project_id_str])
    if @board.header.phases.any?
      render :show
    else
      render :bootstrap
    end
  end
end
