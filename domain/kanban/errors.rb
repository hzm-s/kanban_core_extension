module Kanban
  class CardNotFound < StandardError; end
  class WipLimitReached < StandardError; end
end
