class ProjectLaunchingsController < ApplicationController

  def new
    @form = LaunchProjectForm.new
  end

  def create
    @form = LaunchProjectForm.new(params[:launch_project_form])
    if @form.valid?
      project_service.launch(@form.description)
      redirect_to root_url, notice: 'Project has launched!'
    else
      flash.now[:alert] = "Ooops!"
      render :new
    end
  end

  private

    def project_service
      service = ProjectService.new(
        ProjectRepository.new,
        Kanban::BoardBuilder.new(BoardRepository.new)
      )
    end
end
