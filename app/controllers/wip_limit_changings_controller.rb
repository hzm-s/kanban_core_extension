class WipLimitChangingsController < ApplicationController

  def new
    @command = ChangeWipLimitCommand.new(
      project_id_str: params[:project_id_str],
      phase_name: params[:phase_name]
    )
    render 'modal_window_form', locals: { path: 'boards/new_wip_limit_changing' }
  end

  def create
    @command = ChangeWipLimitCommand.new(params[:change_wip_limit_command])
    if @command.execute(workflow_service)
      flash[:notice] = 'WIP制限の値を変更しました。'
      render 'redirect_from_modal', locals: { to: board_url(@command.project_id_str) }
    else
      render 'modal_window_form', locals: { path: 'boards/new_wip_limit_changing' }
    end
  end
end
