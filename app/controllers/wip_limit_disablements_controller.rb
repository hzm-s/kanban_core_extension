class WipLimitDisablementsController < ApplicationController

  def new
    @command = DisableWipLimitCommand.new(
      project_id_str: params[:project_id_str],
      phase_name: params[:phase_name]
    )
    render 'modal_window_form', locals: { path: 'boards/new_wip_limit_disablement' }
  end

  def create
    @command = DisableWipLimitCommand.new(params[:disable_wip_limit_command])
    if @command.execute(wip_limit_service)
      flash[:notice] = 'WIP制限を解除しました。'
      render 'redirect_from_modal', locals: { to: board_url(@command.project_id_str) }
    else
      render 'modal_window_form', locals: { path: 'boards/new_wip_limit_disablement' }
    end
  end
end
