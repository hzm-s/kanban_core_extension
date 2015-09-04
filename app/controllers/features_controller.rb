class FeaturesController < ApplicationController

  def new
    @form = AddFeatureForm.new
    @form.project_id_str = params[:project_id_str]
  end

  def create
    @form = AddFeatureForm.new(params[:add_feature_form])
    if @form.valid?
      @form.prefer(service)
      redirect_to backlog_url(@form.project_id_str), notice: 'Feature added to backlog!'
    else
      flash.now[:alert] = 'Ooops!'
      render :new
    end
  end

  private

    def service
      FeatureService.new(FeatureRepository.new)
    end
end
