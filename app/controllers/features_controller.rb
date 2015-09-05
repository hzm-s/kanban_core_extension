class FeaturesController < ApplicationController

  def new
    @command = AddFeatureCommand.new.tap do |c|
      c.project_id_str = params[:project_id_str]
    end
  end

  def create
    @command = AddFeatureCommand.new(params[:add_feature_command])
    if @command.execute(feature_service)
      redirect_to backlog_url(@command.project_id_str), notice: 'Feature added to backlog!'
    else
      flash.now[:alert] = 'Ooops!'
      render :new
    end
  end
end
