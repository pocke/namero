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
    end

    def fill_candidates
      board.each_values.with_index do |v, idx|
        next unless v.value
        board[idx, :row].each do |v2|
          unless v2.value
            v2.candidates -= [v.value]
            queue << idx
          end
        end
        board[idx, :column].each do |v2|
          unless v2.value
            v2.candidates -= [v.value]
            queue << idx
          end
        end
        board[idx, :block].each do |v2|
          unless v2.value
            v2.candidates -= [v.value]
            queue << idx
          end
        end
        v.candidates = [v.value]
      end
    end

    def n
      board.n
    end
  end
end
