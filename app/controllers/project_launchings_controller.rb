class ProjectLaunchingsController < ApplicationController

  def new
    @command = LaunchProjectCommand.new
  end

  def create
    @command = LaunchProjectCommand.new(params[:launch_project_command])
    if @command.execute(project_service)
      redirect_to root_url, notice: 'Project has launched!'
    else
      flash.now[:alert] = 'Ooops!'
      render :new
    end
  end
end
