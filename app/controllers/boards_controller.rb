class BoardsController < ApplicationController

  def show
    @board = BoardView.generate(params[:project_id_str])
  end
end
