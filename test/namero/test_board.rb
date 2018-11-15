require 'test_helper'

class TestBoard < Minitest::Test
  def test_board_new
    board = Namero::Board.new(n: 4)
    assert_values [
      nil, nil, nil, nil,
      nil, nil, nil, nil,
      nil, nil, nil, nil,
      nil, nil, nil, nil,
    ], board
  end

  def test_set_row
    board = Namero::Board.new(n: 4)
    board[0, :row] = [1, 2, 3, 4]
    board[15, :row] = [4, nil, 2, 1]
    assert_values [
      1,   2,   3,   4,
      nil, nil, nil, nil,
      nil, nil, nil, nil,
      4,   nil, 2,   1,
    ], board
  end

  def test_set_column
    board = Namero::Board.new(n: 4)
    board[0, :column] = [1, 2, 3, 4]
    board[7, :column] = [4, 3, nil, 1]
    assert_values [
      1, nil, nil, 4,
      2, nil, nil, 3,
      3, nil, nil, nil,
      4, nil, nil, 1,
    ], board
  end

  def test_set_block
    board = Namero::Board.new(n: 4)
    board[1, :block] = [1, 2, 3, 4]
    board[6, :block] = [2, 3, 4, 1]
    board[9, :block] = [1, 3, 2, 4]
    board[14, :block] = [4, 2, 1, 3]
    assert_values [
      1, 2, 2, 3,
      3, 4, 4, 1,
      1, 3, 4, 2,
      2, 4, 1, 3,
    ], board
  end

  def test_get_row
    board = Namero::Board.new(n: 4, values: [
      1,   nil, nil, 4,
      nil, nil, nil, nil,
      nil, 3,   2,   nil,
      nil, nil, nil, nil,
    ])
    assert_equal [1, nil, nil, 4], board[0, :row]
    assert_equal [nil, 3, 2, nil], board[9, :row]
  end

  def test_get_column
    board = Namero::Board.new(n: 4, values: [
      4,   nil, nil, nil,
      nil, nil, 2,   nil,
      3,   nil, 1,   nil,
      nil, nil, nil, nil,
    ])
    assert_equal [4, nil, 3, nil], board[4, :column]
    assert_equal [nil, 2, 1, nil], board[2, :column]
  end

  def test_get_block
    board = Namero::Board.new(n: 4, values: [
      4,   1,   1,   3,
      2,   3,   2,   2,
      3,   1,   1,   3,
      2,   4,   4,   2,
    ])
    assert_equal [4, 1, 2, 3], board[0, :block]
    assert_equal [1, 3, 2, 2], board[3, :block]
    assert_equal [3, 1, 2, 4], board[9, :block]
    assert_equal [1, 3, 4, 2], board[10, :block]
  end

  def assert_values(expected, board)
    got = board.instance_variable_get(:@values)
    assert_equal expected, got
  end
end
