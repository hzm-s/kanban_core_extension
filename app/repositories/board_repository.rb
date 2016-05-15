class BoardRepository

  def find(project_id)
    Kanban::Board
      .includes(:cards)
      .find_by(project_id: project_id)
  end

  def store(board)
    board.save!
  end
end
