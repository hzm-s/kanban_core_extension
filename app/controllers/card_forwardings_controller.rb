class CardForwardingsController < ApplicationController

  def create
    command = ForwardCardCommand.new(params[:forward_card_command])
    if command.execute(board_service)
      redirect_to board_url(command.project_id_str), notice: 'Card forwarded'
    else
      redirect_to board_url(command.project_id_str), alert: command.errors.full_messages.join('<br>')
    end
  end
end
