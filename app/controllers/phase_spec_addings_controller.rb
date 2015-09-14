class PhaseSpecAddingsController < ApplicationController

  def new
    @command = AddPhaseSpecCommand.new(
      project_id_str: params[:project_id_str],
      phase_name: params[:phase_name]
    )
    render 'modal_window_form', locals: { path: 'boards/new_phase_spec_adding' }
  end
end
