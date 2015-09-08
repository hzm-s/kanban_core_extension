class BacklogsController < ApplicationController

  def show
    @wip_count = CardRecord.count(params[:project_id_str])
    @backlog = View::Backlog.build(params[:project_id_str])
  end
end
