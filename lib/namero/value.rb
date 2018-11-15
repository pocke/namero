module Namero
  class Value
    attr_reader :value
    attr_accessor :candidates

    def initialize(value:, candidates:)
      @value = value
      @candidates = candidates
    end

    def dup
      self.new(value: value, candidates: candidates.dup)
    end
  end
end
