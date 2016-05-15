class FeaturesController < ApplicationController

  def new
    @command = AddFeatureCommand.new.tap do |c|
      c.project_id_str = params[:project_id_str]
    end
  end

  def create
    @command = AddFeatureCommand.new(command_params)
    if @command.execute(feature_service)
      redirect_to backlog_url(@command.project_id_str), notice: 'Feature added to backlog!'
    else
      flash.now[:alert] = 'Ooops!'
      render :new
    end
  end

  private

    def command_params
      params.require(:add_feature_command).permit(
        :project_id_str, :summary, :detail
      )
    end
end
