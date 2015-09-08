module View
  Stats = Struct.new(:counts) do
    class << self

      def build(project_id_str, concerns)
        new(Hash[*concerns.flat_map {|c| [c, send(c, project_id_str)] }])
      end

      def backlogs(project_id_str)
        BackloggedFeatureRecord.count(project_id_str)
      end

      def wip(project_id_str)
        CardRecord.count(project_id_str)
      end

      def ships(project_id_str)
        ShippedFeatureRecord.count(project_id_str)
      end
    end

    def backlogs
      counts[:backlogs]
    end

    def wip
      counts[:wip]
    end

    def ships
      counts[:ships]
    end
  end
end
