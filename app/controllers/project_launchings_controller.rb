class ProjectLaunchingsController < ApplicationController

  def new
    @command = LaunchProjectCommand.new
  end

  def create
    @command = LaunchProjectCommand.new(command_params)
    if @command.execute(project_service)
      redirect_to root_url, notice: 'Project has launched!'
    else
      flash.now[:alert] = 'Ooops!'
      render :new
    end
  end

  private

    def command_params
      params.require(:launch_project_command).permit(
        :name, :goal, :kickstart
      )
    end
end
