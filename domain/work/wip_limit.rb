module Work
  class WipLimit

    def initialize(limit)
      @limit = limit
    end

    def reach?(wip)
      @limit <= wip
    end
  end

  class WipLimit
    class None

      def reach?(wip)
        false
      end
    end
  end
end
