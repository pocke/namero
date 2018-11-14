module Namero
  class Solver
    def initialize(board)
      @board = board
    end

    def solve
      loop do
        unless solve_fill_row
          break
        end
      end
    end

    private

    attr_reader :board

    def solve_fill_row
      filled = false
      n.times do |idx|
        row = board[n, type: :row]
        idx = row.find_index(nil)
        next unless idx
        candidates = (1..n).to_a - row
        next unless candidates.size == 1
        row[idx] = candidates[0]
      end
      filled
    end

    def n
      board.n
    end
  end
end
