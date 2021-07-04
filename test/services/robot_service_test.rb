require "test_helper"

class RobotServiceTest < ActiveSupport::TestCase
  def setup
    @robot = Robot.default
  end

  test "data - without placed robot" do
    data = RobotService.new(@robot).data
    expected_data = {
      "direction" => nil,
      "row_position" => nil,
      "column_position" => nil
    }
    assert_equal expected_data, data
  end

  test "data - with placed robot" do
    place_robot(1, 1, EAST)
    data = RobotService.new(@robot).data
    expected_data = {
      "direction" => EAST,
      "row_position" => 1,
      "column_position" => 1
    }
    assert_equal expected_data, data
  end

  test "place - without placed robot" do
    # invalid place params
    place_params = {
      row_position: "invalid",
      column_position: "invalid",
      direction: "invalid"
    }
    result = RobotService.new(@robot).place(place_params)
    assert_equal false, result
    assert_nil @robot.direction
    assert_nil @robot.row_position
    assert_nil @robot.column_position

    # valid place params
    place_params = {
      row_position: "1",
      column_position: "1",
      direction: "EAST"
    }
    result = RobotService.new(@robot).place(place_params)
    assert_equal true, result
    assert_equal EAST, @robot.direction
    assert_equal 1, @robot.row_position
    assert_equal 1, @robot.column_position
  end

  test "place - with placed robot" do
    # invalid place params
    place_robot(1, 1, EAST)
    place_params = {
      row_position: "invalid",
      column_position: "invalid",
      direction: "invalid"
    }
    result = RobotService.new(@robot).place(place_params)
    assert_equal false, result
    assert_equal EAST, @robot.direction
    assert_equal 1, @robot.row_position
    assert_equal 1, @robot.column_position

    # valid place params
    place_robot(1, 1, EAST)
    place_params = {
      row_position: "2",
      column_position: "2",
      direction: "WEST"
    }
    result = RobotService.new(@robot).place(place_params)
    assert_equal true, result
    assert_equal WEST, @robot.direction
    assert_equal 2, @robot.row_position
    assert_equal 2, @robot.column_position

    # invalid positions
    place_robot(1, 1, EAST)
    place_params = {
      row_position: TOTAL_ROWS + 1,
      column_position: TOTAL_COLUMNS + 1,
      direction: "WEST"
    }
    result = RobotService.new(@robot).place(place_params)
    assert_equal false, result
    assert_equal EAST, @robot.direction
    assert_equal 1, @robot.row_position
    assert_equal 1, @robot.column_position
  end

  test "move - without placed robot" do
    result = RobotService.new(@robot).move
    assert_equal false, result
  end

  test "move - with placed robot - with invalid move" do
    # south move
    place_robot(1, 1, SOUTH)
    result = RobotService.new(@robot).move
    assert_equal false, result

    # west move
    place_robot(1, 1, WEST)
    result = RobotService.new(@robot).move
    assert_equal false, result

    # east move
    place_robot(TOTAL_ROWS, TOTAL_COLUMNS, EAST)
    result = RobotService.new(@robot).move
    assert_equal false, result

    # north move
    place_robot(TOTAL_ROWS, TOTAL_COLUMNS, NORTH)
    result = RobotService.new(@robot).move
    assert_equal false, result
  end

  test "move - with placed robot - with valid move" do
    # north move
    place_robot(TOTAL_ROWS - MOVE_STEPS, TOTAL_COLUMNS, NORTH)
    result = RobotService.new(@robot).move
    assert_equal true, result
    assert_equal NORTH, @robot.direction
    assert_equal TOTAL_ROWS, @robot.row_position
    assert_equal TOTAL_COLUMNS, @robot.column_position

    # east move
    place_robot(TOTAL_ROWS, TOTAL_COLUMNS - MOVE_STEPS, EAST)
    result = RobotService.new(@robot).move
    assert_equal true, result
    assert_equal EAST, @robot.direction
    assert_equal TOTAL_ROWS, @robot.row_position
    assert_equal TOTAL_COLUMNS, @robot.column_position

    # south move
    place_robot(TOTAL_ROWS, TOTAL_COLUMNS, SOUTH)
    result = RobotService.new(@robot).move
    assert_equal true, result
    assert_equal SOUTH, @robot.direction
    assert_equal TOTAL_ROWS - MOVE_STEPS, @robot.row_position
    assert_equal TOTAL_COLUMNS, @robot.column_position


    # west move
    place_robot(TOTAL_ROWS, TOTAL_COLUMNS, WEST)
    result = RobotService.new(@robot).move
    assert_equal true, result
    assert_equal WEST, @robot.direction
    assert_equal TOTAL_ROWS, @robot.row_position
    assert_equal TOTAL_COLUMNS - MOVE_STEPS, @robot.column_position
  end

  test "reset - without placed robot" do
    data = RobotService.new(@robot).reset
    assert_nil @robot.direction
    assert_nil @robot.row_position
    assert_nil @robot.column_position
  end

  test "reset - with placed robot" do
    place_robot(1, 1, EAST)
    data = RobotService.new(@robot).reset
    assert_nil @robot.direction
    assert_nil @robot.row_position
    assert_nil @robot.column_position
  end

  test "rotate - without placed robot" do
    # invalid signal
    result = RobotService.new(@robot).rotate("invalid")
    assert_equal false, result

    # valid signal
    result = RobotService.new(@robot).rotate(ROTATE_LEFT_SIGNAL)
    assert_equal false, result
  end

  test "rotate - with placed robot - with invalid signal" do
    place_robot(1, 1, EAST)
    result = RobotService.new(@robot).rotate("invalid")
    assert_equal false, result
  end

  test "rotate - with placed robot - with left signal" do
    # robot direction = east
    place_robot(1, 1, EAST)
    result = RobotService.new(@robot).rotate(ROTATE_LEFT_SIGNAL)
    assert_equal true, result
    assert_equal NORTH, @robot.direction

    # robot direction = west
    place_robot(1, 1, WEST)
    result = RobotService.new(@robot).rotate(ROTATE_LEFT_SIGNAL)
    assert_equal true, result
    assert_equal SOUTH, @robot.direction

    # robot direction = north
    place_robot(1, 1, NORTH)
    result = RobotService.new(@robot).rotate(ROTATE_LEFT_SIGNAL)
    assert_equal true, result
    assert_equal WEST, @robot.direction

    # robot direction = south
    place_robot(1, 1, SOUTH)
    result = RobotService.new(@robot).rotate(ROTATE_LEFT_SIGNAL)
    assert_equal true, result
    assert_equal EAST, @robot.direction
  end

  test "rotate - with placed robot - with right signal" do
    # robot direction = east
    place_robot(1, 1, EAST)
    result = RobotService.new(@robot).rotate(ROTATE_RIGHT_SIGNAL)
    assert_equal true, result
    assert_equal SOUTH, @robot.direction

    # robot direction = west
    place_robot(1, 1, WEST)
    result = RobotService.new(@robot).rotate(ROTATE_RIGHT_SIGNAL)
    assert_equal true, result
    assert_equal NORTH, @robot.direction

    # robot direction = north
    place_robot(1, 1, NORTH)
    result = RobotService.new(@robot).rotate(ROTATE_RIGHT_SIGNAL)
    assert_equal true, result
    assert_equal EAST, @robot.direction

    # robot direction = south
    place_robot(1, 1, SOUTH)
    result = RobotService.new(@robot).rotate(ROTATE_RIGHT_SIGNAL)
    assert_equal true, result
    assert_equal WEST, @robot.direction
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
end