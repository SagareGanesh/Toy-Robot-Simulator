require "test_helper"

class RobotsControllerTest < ActionDispatch::IntegrationTest
  test "#dashboard return success" do
    get robots_dashboard_url
    assert_response :success
  end

  test "#dashboard reset robot" do
    robot = Robot.default
    assert_nil robot.direction
    assert_nil robot.row_position
    assert_nil robot.column_position
  end

  test "#rotate - without robot placed - with invalid params" do
    put robots_rotate_url, params: { signal: "invalid" }
    assert_response :success
    assert_equal response_body, JSON.parse(@response.body)
  end

  test "#rotate - without robot placed - with valid params" do
    put robots_rotate_url, params: { signal: "LEFT" }
    assert_response :success
    assert_equal response_body, JSON.parse(@response.body)
  end

  test "#rotate - with robot placed - with invalid signal" do
    place_robot(1, 1, EAST)
    put robots_rotate_url, params: { signal: "invalid" }
    assert_response :success
    assert_equal response_body(1, 1, EAST), JSON.parse(@response.body)
  end

  test "#rotate - with robot placed - with left signal" do
    # robot direction = east
    place_robot(1, 1, EAST)
    put robots_rotate_url, params: { signal: ROTATE_LEFT_SIGNAL }
    assert_response :success
    assert_equal response_body(1, 1, NORTH), JSON.parse(@response.body)

    # robot direction = west
    place_robot(1, 1, WEST)
    put robots_rotate_url, params: { signal: ROTATE_LEFT_SIGNAL }
    assert_response :success
    assert_equal response_body(1, 1, SOUTH), JSON.parse(@response.body)

    # robot direction = south
    place_robot(1, 1, SOUTH)
    put robots_rotate_url, params: { signal: ROTATE_LEFT_SIGNAL }
    assert_response :success
    assert_equal response_body(1, 1, EAST), JSON.parse(@response.body)

    # robot direction = north
    place_robot(1, 1, NORTH)
    put robots_rotate_url, params: { signal: ROTATE_LEFT_SIGNAL }
    assert_response :success
    assert_equal response_body(1, 1, WEST), JSON.parse(@response.body)
  end

  test "#rotate - with robot placed - with right signal" do
    # robot direction = east
    place_robot(1, 1, EAST)
    put robots_rotate_url, params: { signal: ROTATE_RIGHT_SIGNAL }
    assert_response :success
    assert_equal response_body(1, 1, SOUTH), JSON.parse(@response.body)

    # robot direction = west
    place_robot(1, 1, WEST)
    put robots_rotate_url, params: { signal: ROTATE_RIGHT_SIGNAL }
    assert_response :success
    assert_equal response_body(1, 1, NORTH), JSON.parse(@response.body)

    # robot direction = south
    place_robot(1, 1, SOUTH)
    put robots_rotate_url, params: { signal: ROTATE_RIGHT_SIGNAL }
    assert_response :success
    assert_equal response_body(1, 1, WEST), JSON.parse(@response.body)

    # robot direction = north
    place_robot(1, 1, NORTH)
    put robots_rotate_url, params: { signal: ROTATE_RIGHT_SIGNAL }
    assert_response :success
    assert_equal response_body(1, 1, EAST), JSON.parse(@response.body)
  end

  test "#move - without robot placed - with invalid params" do
    put robots_move_url, params: { direction: "invalid" }
    assert_response :success
    assert_equal response_body, JSON.parse(@response.body)
  end

  test "#move - without robot placed - with valid params" do
    put robots_move_url, params: { direction: EAST }
    assert_response :success
    assert_equal response_body, JSON.parse(@response.body)
  end

  test "#move - with robot placed - with invalid moves" do
    # south move
    place_robot(1, 1, SOUTH)
    put robots_move_url
    assert_response :success
    assert_equal response_body(1, 1, SOUTH), JSON.parse(@response.body)

    # west move
    place_robot(1, 1, WEST)
    put robots_move_url
    assert_response :success
    assert_equal response_body(1, 1, WEST), JSON.parse(@response.body)

    # east move
    place_robot(TOTAL_ROWS, TOTAL_COLUMNS, EAST)
    put robots_move_url
    assert_response :success
    assert_equal response_body(TOTAL_ROWS, TOTAL_COLUMNS, EAST), JSON.parse(@response.body)

    # north move
    place_robot(TOTAL_ROWS, TOTAL_COLUMNS, NORTH)
    put robots_move_url
    assert_response :success
    assert_equal response_body(TOTAL_ROWS, TOTAL_COLUMNS, NORTH), JSON.parse(@response.body)
  end

  test "#move - with robot placed - with valid moves" do
    # north move
    place_robot(TOTAL_ROWS - MOVE_STEPS, TOTAL_COLUMNS, NORTH)
    put robots_move_url
    assert_response :success
    assert_equal response_body(TOTAL_ROWS, TOTAL_COLUMNS, NORTH), JSON.parse(@response.body)

    # east move
    place_robot(TOTAL_ROWS, TOTAL_COLUMNS - MOVE_STEPS, EAST)
    put robots_move_url
    assert_response :success
    assert_equal response_body(TOTAL_ROWS, TOTAL_COLUMNS, EAST), JSON.parse(@response.body)

    # south move
    place_robot(TOTAL_ROWS, TOTAL_COLUMNS, SOUTH)
    put robots_move_url
    assert_response :success
    assert_equal response_body(TOTAL_ROWS - MOVE_STEPS, TOTAL_COLUMNS, SOUTH), JSON.parse(@response.body)

    # west move
    place_robot(TOTAL_ROWS, TOTAL_COLUMNS, WEST)
    put robots_move_url
    assert_response :success
    assert_equal response_body(TOTAL_ROWS, TOTAL_COLUMNS - MOVE_STEPS, WEST), JSON.parse(@response.body)
  end

  test "#report - without robot placed" do
    get robots_report_url
    assert_response :success
    assert_equal response_body, JSON.parse(@response.body)
  end

  test "#report - with robot placed" do
    place_robot(1, 1, SOUTH)
    get robots_report_url
    assert_response :success
    assert_equal response_body(1, 1, SOUTH), JSON.parse(@response.body)
  end

  test "#place - with invalid params" do
    post robots_place_url,
      params: { robot: { row_position: "invalid", column_position: "invalid", direction: "invalid" }}
    assert_response :success
    assert_equal response_body, JSON.parse(@response.body)
  end

  test "#place - with valid params" do
    # invalid positions
    post robots_place_url,
      params: { robot: { row_position: TOTAL_ROWS + 1, column_position: TOTAL_COLUMNS + 1, direction: SOUTH }}
    assert_response :success
    assert_equal response_body, JSON.parse(@response.body)

    # valid positions
    post robots_place_url,
      params: { robot: { row_position: 1, column_position: 1, direction: SOUTH }}
    assert_response :success
    assert_equal response_body(1, 1, SOUTH), JSON.parse(@response.body)
  end

  private

    def response_body(row_position = nil, column_position = nil, direction = nil)
      {
        "direction" => direction,
        "row_position" => row_position,
        "column_position" => column_position
      }
    end

    def place_robot(row_position, column_position, direction)
      place_params = {
        row_position: row_position,
        column_position: column_position,
        direction: direction
      }

      RobotService.new(Robot.default).place(place_params)
    end
end
