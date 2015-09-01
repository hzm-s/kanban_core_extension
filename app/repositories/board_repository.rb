class BoardRepository

  def find(project_id)
    Kanban::Board.find_by(project_id_str: project_id.to_s)
  end

  def store(board)
    board.save!
  end
end
