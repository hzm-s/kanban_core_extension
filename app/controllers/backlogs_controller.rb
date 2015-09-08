class BacklogsController < ApplicationController

  def show
    @stats = View::Stats.build(params[:project_id_str], [:wip, :ships])
    @backlog = View::Backlog.build(params[:project_id_str])
  end
end
