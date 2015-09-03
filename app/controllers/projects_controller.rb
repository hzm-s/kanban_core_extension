class ProjectsController < ApplicationController

  def index
    @projects = ProjectRecord.all
  end
end
