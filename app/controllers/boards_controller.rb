class BoardsController < ApplicationController

  def show
    @board = BoardView.find(params[:project_id_str])
  end
end
