require "test_helper"

class MovePositionTest < ActiveSupport::TestCase
  def setup
    @robot = Robot.default
  end

  test "with unplaced robot" do
    result, move_positions = MovePosition.new(@robot).call
    assert_equal false, result
  end

  test "with placed robot - invalid moves" do
    # south move
    place_robot(1, 1, SOUTH)
    result, move_positions = MovePosition.new(@robot).call
    assert_equal false, result

    # west move
    place_robot(1, 1, WEST)
    result, move_positions = MovePosition.new(@robot).call
    assert_equal false, result

    # east move
    place_robot(TOTAL_ROWS, TOTAL_COLUMNS, EAST)
    result, move_positions = MovePosition.new(@robot).call
    assert_equal false, result

    # north move
    place_robot(TOTAL_ROWS, TOTAL_COLUMNS, NORTH)
    result, move_positions = MovePosition.new(@robot).call
    assert_equal false, result
  end

  test "with placed robot - valid moves" do
    # north move
    place_robot(TOTAL_ROWS - MOVE_STEPS, TOTAL_COLUMNS, NORTH)
    result, move_positions = MovePosition.new(@robot).call
    assert_equal true, result
    assert_equal response_body(TOTAL_ROWS, TOTAL_COLUMNS), move_positions

    # east move
    place_robot(TOTAL_ROWS, TOTAL_COLUMNS - MOVE_STEPS, EAST)
    result, move_positions = MovePosition.new(@robot).call
    assert_equal true, result
    assert_equal response_body(TOTAL_ROWS, TOTAL_COLUMNS), move_positions

    # south move
    place_robot(TOTAL_ROWS, TOTAL_COLUMNS, SOUTH)
    result, move_positions = MovePosition.new(@robot).call
    assert_equal true, result
    assert_equal response_body(TOTAL_ROWS - MOVE_STEPS, TOTAL_COLUMNS), move_positions

    # west move
    place_robot(TOTAL_ROWS, TOTAL_COLUMNS, WEST)
    result, move_positions = MovePosition.new(@robot).call
    assert_equal true, result
    assert_equal response_body(TOTAL_ROWS, TOTAL_COLUMNS - MOVE_STEPS), move_positions
  end

  private

    def place_robot(row_position, column_position, direction)
      place_params = {
        row_position: row_position,
        column_position: column_position,
        direction: direction
      }

      RobotService.new(@robot).place(place_params)
    end

    def response_body(row_position, column_position)
      { row_position: row_position, column_position: column_position }
    end
end