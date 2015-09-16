class TransitionSettings < ApplicationController

  def new
    @command = SetTransitionCommand.new(
      project_id_str: params[:project_id_str],
      phase_name: params[:phase_name],
      state_names: [nil, nil]
    )
    render 'modal_window_form', locals: { path: 'boards/new_transition_setting' }
  end
end
