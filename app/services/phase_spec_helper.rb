module PhaseSpecHelper

  def replace_phase_spec(project, phase)
    project_id = project.project_id
    workflow = project.workflow
    phase_spec = workflow.spec(phase)

    workflow_builder = Activity::WorkflowBuilder.new(workflow)
    phase_spec_builder = Activity::PhaseSpecBuilder.new(project_id, phase_spec)

    yield(phase_spec_builder)

    workflow_builder.replace_phase_spec(phase_spec_builder.build_phase_spec, phase)
    workflow_builder.build_workflow
  end
end
