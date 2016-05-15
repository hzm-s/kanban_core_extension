module View
  Backlog = Struct.new(:project_id, :project_name, :features) do

    def self.build(project_id)
      project = ProjectRecord.find_by(project_id: project_id)
      features = BackloggedFeatureRecord
                   .with_project(project.project_id)
                   .map {|r| Feature.new(r) }
      new(
        project.project_id,
        project.name,
        features
      )
    end

    Feature = Struct.new(:number, :project_id, :feature_id, :summary, :detail) do

      def initialize(hash)
        super(
          *hash.values_at(
            'number',
            'project_id',
            'feature_id',
            'description_summary',
            'description_detail'
          )
        )
      end

      def add_card_command
        AddCardCommand.new(
          project_id_str: project_id,
          feature_id_str: feature_id
        )
      end
    end
  end
end
