module View
  Backlog = Struct.new(:project_id_str, :project_name, :features) do

    def self.build(project_id_str)
      project = ProjectRecord.find_by(project_id_str: project_id_str)
      features = BackloggedFeatureRecord
                   .with_project(project.project_id_str)
                   .map {|r| Feature.new(r) }
      new(
        project.project_id_str,
        project.name,
        features
      )
    end

    Feature = Struct.new(:number, :project_id_str, :feature_id_str, :summary, :detail) do

      def initialize(hash)
        super(
          *hash.values_at(
            'number',
            'project_id_str',
            'feature_id_str',
            'description_summary',
            'description_detail'
          )
        )
      end

      def add_card_command
        AddCardCommand.new(
          project_id_str: project_id_str,
          feature_id_str: feature_id_str
        )
      end
    end
  end
end
