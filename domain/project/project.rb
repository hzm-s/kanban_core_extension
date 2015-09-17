module Project
  class Project < ActiveRecord::Base
    include Arize::Project

    def specify_workflow(a_workflow)
      self.workflow = a_workflow
    end
  end
end
