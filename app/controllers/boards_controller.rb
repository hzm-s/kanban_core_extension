class BoardsController < ApplicationController
  layout 'board'

  def show
    @board = View::Board.build(params[:project_id_str])
  end
end
