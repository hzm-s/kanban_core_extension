class ProjectIdType < ActiveRecord::Type::String
  def serialize(value)
    project_id = value.to_s
  end

  def deserialize(value)
    ::Project::ProjectId.new(value)
  end
end
