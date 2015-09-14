class WipLimitChangingsController < ApplicationController

  def new
    @command = ChangeWipLimitCommand.new(
      project_id_str: params[:project_id_str],
      phase_name: params[:phase_name]
    )
    render 'modal_window_form', locals: { path: 'boards/new_wip_limit_changing' }
  end

  def create
    command = ChangeWipLimitCommand.new(params[:change_wip_limit_command])
    if command.execute(project_service)
      redirect_to board_url(command.project_id_str), notice: 'WIP Limit Changed'
    else
      redirect_to board_url(command.project_id_str), alert: command.errors.full_messages.join('<br>')
    end
  end
end
