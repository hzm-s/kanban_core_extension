class PhaseSpecAddingsController < ApplicationController

  def new
    @command = AddPhaseSpecCommand.new(
      project_id_str: params[:project_id_str],
      direction: params[:direction],
      base_phase_name: params[:base_phase_name]
    )
    render 'modal_window_form', locals: { path: 'boards/new_phase_spec_adding' }
  end

  def create
    command = AddPhaseSpecCommand.new(params[:add_phase_spec_command])
    if command.execute(workflow_service)
      redirect_to board_url(project_id_str: command.project_id_str), notice: 'ワークフローにフェーズを追加しました。'
    else
      redirect_to board_url(project_id_str: command.project_id_str), alert: command.errors.full_messages.join('<br>')
    end
  end
end
