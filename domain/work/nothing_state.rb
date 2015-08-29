module Work
  class NothingState

    def ==(other)
      other.instance_of?(self.class)
    end
  end
end
