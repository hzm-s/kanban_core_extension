module View
  Stats = Struct.new(:counts) do
    class << self

      def build(project_id, concerns)
        new(Hash[*concerns.flat_map {|c| [c, send(c, project_id)] }])
      end

      def backlogs(project_id)
        BackloggedFeatureRecord.count(project_id)
      end

      def wip(project_id)
        CardRecord.count(project_id)
      end

      def ships(project_id)
        ShippedFeatureRecord.count(project_id)
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
