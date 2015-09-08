class BoardsController < ApplicationController
  layout 'board'

  def show
    @backlogged_count = BackloggedFeatureRecord.count(params[:project_id_str])
    @shipped_count = ShippedFeatureRecord.count(params[:project_id_str])
    @board = View::Board.build(params[:project_id_str])
  end
end
