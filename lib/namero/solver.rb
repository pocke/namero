require 'set'

module Namero
  class Solver
    def initialize(board, extensions: [])
      @board = board
      @updated_candidate_queue = Set.new
      @extensions = extensions
    end

    def solve
      fill_candidates
      loop do
        idx = updated_candidate_queue.first
        unless idx
          extensions.each do |ex|
            ex.solve(board, updated_candidate_queue)
          end
          break if updated_candidate_queue.empty?
          next
        end
        @updated_candidate_queue.delete idx
        fill_one_candidate(idx)
      end
    end

    private

    attr_reader :board, :updated_candidate_queue, :extensions

    def fill_one_candidate(idx)
      v = board[idx]
      return if v.candidates.size != 1
      v.value = v.candidates.first
      fill_candidate_for(v)
    end

    def fill_candidate_for(v)
      board[v.index, :row].each do |v2|
        unless v2.value
          changed = v2.candidates.delete(v.value)
          updated_candidate_queue << v2.index if changed
        end
      end
      board[v.index, :column].each do |v2|
        unless v2.value
          changed = v2.candidates.delete(v.value)
          updated_candidate_queue << v2.index if changed
        end
      end
      board[v.index, :block].each do |v2|
        unless v2.value
          changed = v2.candidates.delete(v.value)
          updated_candidate_queue << v2.index if changed
        end
      end
      v.candidates = [v.value]
    end

    def fill_candidates
      (n ** 2).times do |idx|
        v = board[idx]
        next unless v.value
        fill_candidate_for(v)
      end
    end

    def n
      board.n
    end
  end
end
