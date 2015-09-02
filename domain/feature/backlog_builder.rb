module Backlog
  class BacklogBuilder

    def initialize(backlog_repository)
      @backlog_repository = backlog_repository
    end

    def project_launched(event)
      backlog = ::Backlog::Backlog.new.tap do |backlog|
        backlog.prepare(event.project_id)
      end
      @backlog_repository.store(backlog)
    end
  end
end
