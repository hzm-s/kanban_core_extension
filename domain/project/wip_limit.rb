module Project
  class WipLimit

    def initialize(limit)
      @limit = limit
    end

    def reach?(wip)
      @limit <= wip
    end

    def to_i
      @limit
    end
  end

  class WipLimit
    class None

      def reach?(wip)
        false
      end

      def to_i
        nil
      end
    end
  end
end
