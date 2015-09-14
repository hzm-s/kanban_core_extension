class WorkflowsController < ApplicationController
  layout 'board'

  before_action :load_stats, :load_project

  def new
    @command = AddPhaseSpecCommand.new(project_id_str: params[:project_id_str])
  end

  def create
    @command = AddPhaseSpecCommand.new(params[:add_phase_spec_command])
    if @command.execute(workflow_service)
      redirect_to board_url(project_id_str: @command.project_id_str), notice: 'ワークフローにフェーズを追加しました。'
    else
      flash.now[:alert] = '入力エラーです。'
      render :new
    end
  end

  private

    def load_stats
      @stats = View::Stats.build(params[:project_id_str], [:backlogs, :ships])
    end

    def load_project
      @project = ProjectRecord.find_by(
        project_id_str: params[:project_id_str] ||
                          params[:add_phase_spec_command][:project_id_str]
      )
    end
end
