class RobotService
  attr_accessor :robot

  def initialize(robot)
    @robot = robot
  end

  def data
    robot.as_json(except: :id)
  end

  def place(params)
    return false unless valid_place_params?(params)

    robot_params = {
      row_position: params[:row_position],
      column_position: params[:column_position],
      direction: params[:direction]
    }

    robot.update!(robot_params)
  end

  def move
    return false unless robot.placed?

    is_movable, move_positions = MovePosition.new(robot).call
    return false unless is_movable

    robot.update!(
      row_position: move_positions[:row_position],
      column_position: move_positions[:column_position]
    )
  end

  def rotate(signal)
    return false unless robot.placed?
    return false unless valid_rotate_signal?(signal)

    robot.update!(direction: ROTATE_DIRECTIONS[signal][robot.direction])
  end

  def reset
    robot.update!(
      row_position: nil,
      column_position: nil,
      direction: nil
    )
  end

  private

    def valid_place_params?(params)
      valid_positions?(params[:row_position], params[:column_position]) &&
      valid_direction?(params[:direction])
    end

    def valid_positions?(row_position, column_position)
      Integer(row_position).between?(1, TOTAL_ROWS) && Integer(column_position).between?(1, TOTAL_COLUMNS)
    rescue ArgumentError, TypeError
      false
    end

    def valid_direction?(direction)
      DIRECTIONS.include?(direction)
    end

    def valid_rotate_signal?(signal)
      ROTATE_SIGNALS.include?(signal)
    end

    def move_info_for(direction)
      MovePosition.new(
        row_position: robot.row_position,
        column_position: robot.column_position,
        direction: robot.direction
      ).call
    end

end