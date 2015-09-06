class CardAddingsController < ApplicationController

  def create
    command = AddCardCommand.new(params[:add_card_command])
    if command.execute(board_service)
      redirect_to board_url(command.project_id_str), notice: 'Card added'
    else
      redirect_to backlog_url(command.project_id_str), alert: command.errors.full_messages.join('<br>')
    end
  end
end
