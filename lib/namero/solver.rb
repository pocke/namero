module Namero
  class Solver
    def initialize(board)
      @board = board
    end

    def solve
      fill_candidates
    end

    private

    attr_reader :board, :candidate_board

    def fill_candidates
      board.each_values do |v, x, y|
        next unless v

      end
    end

    def n
      board.n
    end
  end
end
