require 'test_helper'

class TestBoard < Minitest::Test
  def test_fill_candidates
    board = board_from_string(<<~END.chomp)
      1xxx
      xxxx
      xxxx
      xxxx
    END
    s = Namero::Solver.new(board)
    s.__send__(:fill_candidates)
    check_candidates(<<~END.chomp, board)
      1    234  234  234
      234  234  1234 1234
      234  1234 1234 1234
      234  1234 1234 1234
    END
  end

  def test_fill_candidates2
    board = board_from_string(<<~END.chomp)
      xx4x
      xxx1
      4xxx
      21xx
    END
    s = Namero::Solver.new(board)
    s.__send__(:fill_candidates)
    check_candidates(<<~END.chomp, board)
      13 23  4   23
      3  234 23  1
      4  3   123 23
      2  1   3   34
    END
  end

  def board_from_string(str)
    n = 4
    values = str.split("\n").map(&:chars).flatten.map do |v|
      if v == 'x'
        Namero::Value.new(value: nil, candidates: (1..n).to_a)
      else
        Namero::Value.new(value: Integer(v), candidates: [Integer(v)])
      end
    end
    Namero::Board.new(n: n, values: values)
  end

  def check_candidates(str, board)
    values = board.instance_variable_get(:@values)
    str.split(/\s+/).each.with_index do |expected, idx|
      got = values[idx].candidates
      expected = expected.chars.map(&:to_i)
      assert_equal expected, got, "idx: #{idx}"
    end
  end
end
