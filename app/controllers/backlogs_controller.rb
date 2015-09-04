class BacklogsController < ApplicationController

  def show
    @backlog = View::Backlog.build(params[:project_id_str])
  end
end
