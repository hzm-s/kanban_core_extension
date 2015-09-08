class ResultsController < ApplicationController

  def show
    @stats = View::Stats.build(params[:project_id_str], [:backlogs, :wip])
    @result = View::Result.build(params[:project_id_str])
  end
end
