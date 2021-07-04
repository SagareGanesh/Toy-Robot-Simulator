class RobotsController < ApplicationController
  before_action :load_robot_service
  skip_before_action :verify_authenticity_token

  # GET dashboard
  #
  def dashboard
    @robot_service.reset
  end

  # POST place
  #
  # params = {
  #   robot: {
  #     direction: "NORTH",
  #     row_position: "1",
  #     column_position: "1"
  #   }
  # }
  #
  def place
    @robot_service.place(place_params)
    render json: @robot_service.data
  end

  # PUT rotate
  #
  # params = { signal: "LEFT" }
  #
  def rotate
    @robot_service.rotate(rotate_params[:signal])
    render json: @robot_service.data
  end

  # PUT move
  #
  def move
    @robot_service.move
    render json: @robot_service.data
  end

  # GET report
  #
  def report
    render json: @robot_service.data
  end

  private

    def load_robot_service
      @robot_service = RobotService.new(Robot.default)
    end

    def place_params
      params.require(:robot).permit(:row_position, :column_position, :direction)
    end

    def rotate_params
      params.permit(:signal)
    end
end
