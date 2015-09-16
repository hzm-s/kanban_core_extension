class StateAddingsController < ApplicationController

  def new
    @command = AddStateCommand.new(
      project_id_str: params[:project_id_str],
      phase_name: params[:phase_name],
      direction: params[:direction],
      base_state_name: params[:base_state_name]
    )
    render 'modal_window_form', locals: { path: 'boards/new_state_adding' }
  end
end
