class BoardsController < ApplicationController
  layout 'board'

  def show
    @stats = View::Stats.build(params[:project_id_str], [:backlogs, :ships])
    @board = View::Board.build(params[:project_id_str])
  end
end
