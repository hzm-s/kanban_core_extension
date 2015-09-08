class BoardsController < ApplicationController
  layout 'board'

  def show
    @backlogged_count = BackloggedFeatureRecord.count(params[:project_id_str])
    @shipped_count = FeatureRecord
                       .includes(:shipped_feature_record)
                       .where(project_id_str: params[:project_id_str])
                       .where.not(shipped_feature_records: { id: nil })
                       .count
    @board = View::Board.build(params[:project_id_str])
  end
end
