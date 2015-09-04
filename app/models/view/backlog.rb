module View
  Backlog = Struct.new(:project_id_str, :project_name, :features) do

    def self.build(project_id_str)
      project = ProjectRecord.find_by(project_id_str: project_id_str)

      added_features = BoardRecord
                         .eager_load(:card_records)
                         .find_by(project_id_str: project.project_id_str)
                         .card_records
                         .pluck(:feature_id_str)

      features = FeatureRecord
                   .where(project_id_str: project.project_id_str)
                   .order(:id)
                   .reject {|r| added_features.include?(r.feature_id_str) }
                   .map {|r| Feature.new(r) }
      new(
        project.project_id_str,
        project.name,
        features
      )
    end

    class Feature < SimpleDelegator

      def initialize(record)
        super(record)
      end

      def add_card_form
        AddCardForm.new(
          project_id_str: project_id_str,
          feature_id_str: feature_id_str
        )
      end
    end
  end
end
