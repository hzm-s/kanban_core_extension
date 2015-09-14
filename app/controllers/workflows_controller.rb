class WorkflowsController < ApplicationController
  layout 'board'

  before_action :load_stats, :load_project

  def new
    @command = SpecifyWorkflowCommand.new(project_id_str: params[:project_id_str])
  end

  def create
    @command = SpecifyWorkflowCommand.new(params[:specify_workflow_command])
    if @command.valid?
      board_url(project_id_str: @command.project_id_str)
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
                          params[:specify_workflow_command][:project_id_str]
      )
    end
end
