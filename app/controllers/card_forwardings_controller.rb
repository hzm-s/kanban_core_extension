class CardForwardingsController < ApplicationController

  def create
    command = ForwardCardCommand.new(command_params)
    if command.execute(board_service)
      redirect_to board_url(command.project_id_str), notice: 'Card forwarded'
    else
      redirect_to board_url(command.project_id_str), alert: command.errors.full_messages.join('<br>')
    end
  end

  private

    def command_params
      params.require(:forward_card_command).permit(
        :project_id_str, :feature_id_str, :step_phase_name, :step_state_name
      )
    end
end
