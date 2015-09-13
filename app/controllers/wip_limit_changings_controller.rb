class WipLimitChangingsController < ApplicationController

  def create
    command = ChangeWipLimitCommand.new(params[:change_wip_limit_command])
    if command.execute(project_service)
      redirect_to board_url(command.project_id_str), notice: 'WIP Limit Changed'
    else
      redirect_to board_url(command.project_id_str), alert: command.errors.full_messages.join('<br>')
    end
  end
end
