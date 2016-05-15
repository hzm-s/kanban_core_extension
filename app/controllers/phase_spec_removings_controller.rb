class PhaseSpecRemovingsController < ApplicationController

  def new
    @command = RemovePhaseSpecCommand.new(
      project_id_str: params[:project_id_str],
      phase_name: params[:phase_name]
    )
    render 'modal_window_form', locals: { path: 'boards/new_phase_spec_removing' }
  end

  def create
    @command = RemovePhaseSpecCommand.new(command_params)
    if @command.execute(workflow_service)
      flash[:notice] = 'フェーズを削除しました。'
      render 'redirect_from_modal', locals: { to: board_url(@command.project_id_str) }
    else
      render 'modal_window_form', locals: { path: 'boards/new_phase_spec_removing' }
    end
  end

  private

    def command_params
      params.require(:remove_phase_spec_command).permit(
        :project_id_str, :phase_name
      )
    end
end
