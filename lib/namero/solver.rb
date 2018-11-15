module Namero
  class Solver
    def initialize(board)
      @board = board
    end

    def solve
      fill_candidates
    end

    private

    attr_reader :board

    def fill_candidates
      board.each_values do |v, x, y|
        next unless v.value
        board[y, type: :row].each do |v2|
          v2.candidates -= [v.value] unless v2.value
        end
        board[x, type: :column].each do |v2|
          v2.candidates -= [v.value] unless v2.value
        end
        block_index = board.block_index(x, y)
        board[block_index, type: :block].each do |v2|
          v2.candidates -= [v.value] unless v2.value
        end
        v.candidates = [v.value]
      end
    end

    def n
      board.n
    end
  end
end
