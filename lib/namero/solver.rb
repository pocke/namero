require 'set'

module Namero
  class Solver
    def initialize(board)
      @board = board
      @queue = Set.new
    end

    def solve
      fill_candidates
    end

    private

    attr_reader :board, :queue

    def fill_candidate_for(idx)
      v = board[idx]
      return unless v.value

      board[idx, :row].each do |v2|
        unless v2.value
          v2.candidates -= [v.value]
          queue << v.index
        end
      end
      board[idx, :column].each do |v2|
        unless v2.value
          v2.candidates -= [v.value]
          queue << v.index
        end
      end
      board[idx, :block].each do |v2|
        unless v2.value
          v2.candidates -= [v.value]
          queue << v.index
        end
      end
      v.candidates = [v.value]
    end

    def fill_candidates
      (n ** 2).times do |idx|
        fill_candidate_for(idx)
      end
    end

    def n
      board.n
    end
  end
end
