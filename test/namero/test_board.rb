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

  def test_set_single
    board = Namero::Board.new(n: 4)
    board[0, 0] = 3
    board[1, 3] = 4
    assert_values [
      3,   nil, nil, nil,
      nil, nil, nil, nil,
      nil, nil, nil, nil,
      nil, 4,   nil, nil,
    ], board
  end

  def test_set_row
    board = Namero::Board.new(n: 4)
    board[0, type: :row] = [1, 2, 3, 4]
    board[3, type: :row] = [4, nil, 2, 1]
    assert_values [
      1,   2,   3,   4,
      nil, nil, nil, nil,
      nil, nil, nil, nil,
      4,   nil, 2,   1,
    ], board
  end

  def test_set_column
    board = Namero::Board.new(n: 4)
    board[0, type: :column] = [1, 2, 3, 4]
    board[3, type: :column] = [4, 3, nil, 1]
    assert_values [
      1, nil, nil, 4,
      2, nil, nil, 3,
      3, nil, nil, nil,
      4, nil, nil, 1,
    ], board
  end

  def test_get_single
    board = Namero::Board.new(n: 4, values: [
      1,   nil, nil, nil,
      nil, nil, nil, nil,
      nil, 3,   nil, nil,
      nil, nil, nil, nil,
    ])
    assert_equal 1, board[0, 0]
    assert_equal 3, board[1, 2]
  end

  def test_get_row
    board = Namero::Board.new(n: 4, values: [
      1,   nil, nil, 4,
      nil, nil, nil, nil,
      nil, 3,   2,   nil,
      nil, nil, nil, nil,
    ])
    assert_equal [1, nil, nil, 4], board[0, type: :row]
    assert_equal [nil, 3, 2, nil], board[2, type: :row]
  end

  def test_get_column
    board = Namero::Board.new(n: 4, values: [
      4,   nil, nil, nil,
      nil, nil, 2,   nil,
      3,   nil, 1,   nil,
      nil, nil, nil, nil,
    ])
    assert_equal [4, nil, 3, nil], board[0, type: :column]
    assert_equal [nil, 2, 1, nil], board[2, type: :column]
  end

  def assert_values(expected, board)
    got = board.instance_variable_get(:@values)
    assert_equal expected, got
  end
end
