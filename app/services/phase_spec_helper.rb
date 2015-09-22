module PhaseSpecHelper

  def replace_phase_spec(workflow, phase)
    workflow_builder = Activity::WorkflowBuilder.new(workflow)
    phase_spec_builder = Activity::PhaseSpecBuilder.new(workflow.spec(phase))

    yield(phase_spec_builder)

    workflow_builder.replace_phase_spec(phase_spec_builder.build_phase_spec, phase)
    workflow_builder.build_workflow
  end
end
