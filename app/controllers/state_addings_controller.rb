class StateAddingsController < ApplicationController

  def new
    @command = AddStateCommand.new(
      project_id_str: params[:project_id_str],
      phase_name: params[:phase_name],
      position: params[:position],
      base_state_name: params[:base_state_name]
    )
    render 'modal_window_form', locals: { path: 'boards/new_state_adding' }
  end

  def create
    @command = AddStateCommand.new(command_params)
    if @command.execute(phase_spec_service)
      flash[:notice] = 'フェーズに状態を追加しました。'
      render 'redirect_from_modal', locals: { to: board_url(@command.project_id_str) }
    else
      render 'modal_window_form', locals: { path: 'boards/new_state_adding' }
    end
  end

  private

    def command_params
      params.require(:add_state_command).permit(
        :project_id_str, :phase_name, :state_name,
        :position, :base_state_name
      )
    end
end
