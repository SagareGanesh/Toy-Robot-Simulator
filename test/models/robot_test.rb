require "test_helper"

class RobotTest < ActiveSupport::TestCase
  def setup
    @robot = Robot.default
  end

  test "valid withot direction, row_position and column_position" do
    assert @robot.valid?
  end

  test "invalid if direction not included in valid direction" do
    @robot.direction = "invalid"
    assert_equal false, @robot.valid?
    assert_equal ["Direction is not included in the list"], @robot.errors.full_messages
  end

  test "invalid if row_position not included in valid direction" do
    @robot.row_position = "invalid"
    assert_equal false, @robot.valid?
    assert_equal ["Row position is not included in the list"], @robot.errors.full_messages
  end

  test "invalid if column_position not included in valid direction" do
    @robot.column_position = "invalid"
    assert_equal false, @robot.valid?
    assert_equal ["Column position is not included in the list"], @robot.errors.full_messages
  end

  test "placed?" do
    assert_equal @robot.placed?, false

    @robot.update!(direction: EAST)
    assert_equal false, @robot.placed?

    @robot.update!(row_position: 1)
    assert_equal false, @robot.placed?

    @robot.update!(column_position: 1)
    assert_equal true, @robot.placed?
  end

  test "setup!" do
    Robot.destroy_all

    assert_equal 0, Robot.count
    Robot.setup!
    assert_equal 1, Robot.count
    Robot.setup!
    assert_equal 1, Robot.count

    robot = Robot.default
    assert_nil robot.direction
    assert_nil robot.row_position
    assert_nil robot.column_position
  end
end
