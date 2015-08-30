class FakeBoardRepository

  def initialize
    @storage = {}
  end

  def find(project_id)
    @storage[project_id.to_s]
  end

  def store(board)
    @storage.merge!(
      board.project_id.to_s => board
    )
  end
end
