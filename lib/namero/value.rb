module Namero
  class Value
    attr_reader :value, :index
    attr_accessor :candidates

    def initialize(value:, candidates:, index:)
      @value = value
      @candidates = candidates
      @index = index
    end

    def dup
      self.new(value: value, candidates: candidates.dup)
    end
  end
end
