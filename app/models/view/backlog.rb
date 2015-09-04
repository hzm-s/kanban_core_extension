module View
  Backlog = Struct.new(:project_name, :features) do

    def self.build(project_id_str)
      project = ProjectRecord.find_by(project_id_str: project_id_str)
      features = FeatureRecord
                   .where(project_id_str: project_id_str)
                   .order(:id)
                   .to_a
      new(project.name, features)
    end
  end
end
