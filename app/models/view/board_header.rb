module View
  BoardHeader = Struct.new(:phases, :phase_states) do

    def self.build(project_id_str, phase_specs, states)
      builder = BoardHeaderBuilder.new(project_id_str, phase_specs, states)
      new(
        builder.phases,
        builder.phase_states
      )
    end

    Phase = Struct.new(:project_id_str, :name, :wip_limit, :state_size) do

      def self.build(project_id_str, record, state_size)
        new(
          project_id_str,
          record.phase_name,
          record.wip_limit_count,
          state_size
        )
      end

      def change_wip_limit_command
        ChangeWipLimitCommand.new(
          project_id_str: project_id_str,
          phase_name: name,
          wip_limit_count: wip_limit
        )
      end
    end

    State = Struct.new(:phase_name, :name)
  end
end
