class BoardView

  def self.find(project_id_str)
    new(
      ProjectRecord
        .with_workflow
        .find_by(project_id_str: project_id_str),
      BoardRecord
        .find_by(project_id_str: project_id_str)
    )
  end

  def initialize(project_record, board_record)
    @project_record = project_record
    @phase_spec_records = project_record.phase_spec_records
    @state_records = project_record.state_records
    @board_record = board_record
  end

  def project_name
    @project_record.name
  end

  def phase_specs
    @phase_spec_records
  end

  def transition(phase_name)
    @state_records.where(phase_name: phase_name).pluck(:state_name)
  end
end
