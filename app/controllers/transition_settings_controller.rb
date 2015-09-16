class TransitionSettingsController < ApplicationController

  def new
    @command = SetTransitionCommand.new(
      project_id_str: params[:project_id_str],
      phase_name: params[:phase_name],
      state_names: [nil, nil]
    )
    render 'modal_window_form', locals: { path: 'boards/new_transition_setting' }
  end

  def create
    @command = SetTransitionCommand.new(params[:set_transition_command])
    if @command.execute(workflow_service)
      flash[:notice] = 'フェーズに推移を設定しました。'
      render 'redirect_from_modal', locals: { to: board_url(@command.project_id_str) }
    else
      render 'modal_window_form', locals: { path: 'boards/new_transition_setting' }
    end
  end
end
