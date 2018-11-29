module Namero
  module SolverExtensions
    # If a candidate number exists only one place in an affected group,
    # we can fill the box.
    # For example:
    #   When candidates are: [1 2 3] [2 3] [1 2 3] [1 2 3 4]
    #   The last box's value is 4 because there is 4 candidate only the last box.
    class CandidateExistsOnlyOnePlace
      def self.solve(board, queue)
        self.new(board, queue).solve
      end

      def initialize(board, queue)
        @board = board
        @queue = queue
      end

      def solve
        board.each_affected_group do |group|
          (1..n).each do |v|
            box = nil
            group.each do |value|
              if value.candidates.include?(v) && value.value.nil?
                if box
                  box = nil
                  break
                else
                  box = value
                end
              end
            end

            if box
              box.candidates = [v]
              queue << box.index
            end
          end
        end
      end

      private

      attr_reader :board, :queue

      def n
        board.n
      end
    end
  end
end
