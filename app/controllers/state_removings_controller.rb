class StateRemovingsController < ApplicationController

  def new
    @command = RemoveStateCommand.new(
      project_id_str: params[:project_id_str],
      phase_name: params[:phase_name],
      state_name: params[:state_name]
    )
    render 'modal_window_form', locals: { path: 'boards/new_state_removing' }
  end

  def create
    @command = RemoveStateCommand.new(command_params)
    if @command.execute(phase_spec_service)
      flash[:notice] = '状態を削除しました。'
      render 'redirect_from_modal', locals: { to: board_url(@command.project_id_str) }
    else
      render 'modal_window_form', locals: { path: 'boards/new_state_removing' }
    end
  end

  private

    def command_params
      params.require(:remove_state_command).permit(
        :project_id_str, :phase_name, :state_name
      )
    end
end
