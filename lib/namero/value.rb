module Namero
  class Value
    attr_reader :index
    attr_accessor :candidates, :value

    def initialize(value:, candidates:, index:)
      @value = value
      @candidates = candidates
      @index = index
    end

    def dup
      self.class.new(value: value, candidates: candidates.dup, index: index)
    end
  end
end
