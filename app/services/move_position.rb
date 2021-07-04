class MovePosition
  attr_reader :robot

  def initialize(robot)
    @robot = robot
  end

  def call
    return false, {} unless robot.placed?

    move_row_position, move_column_postion = move_positions
    return false, {} unless move_row_position || move_column_postion

    if valid_positions?(move_row_position, move_column_postion)
      return true, { row_position: move_row_position, column_position: move_column_postion }
    else
      return false, {}
    end

  end

  private

    def move_positions
      case robot.direction
      when NORTH then [robot.row_position + MOVE_STEPS, robot.column_position]
      when SOUTH then [robot.row_position - MOVE_STEPS, robot.column_position]
      when EAST  then [robot.row_position, robot.column_position + MOVE_STEPS]
      when WEST  then [robot.row_position, robot.column_position - MOVE_STEPS]
      end
    end

    def valid_positions?(row_position, column_position)
      return false if row_position < 1
      return false if column_position < 1
      return false if row_position > TOTAL_ROWS
      return false if column_position > TOTAL_COLUMNS

      true
    end
end