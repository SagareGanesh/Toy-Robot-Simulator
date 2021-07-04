class Robot < ApplicationRecord
  scope :default, -> { first }

  validates :direction, inclusion: { in: DIRECTIONS, allow_blank: true }
  validates :row_position, inclusion: { in: (1..TOTAL_ROWS).to_a, allow_blank: true }
  validates :column_position, inclusion: { in: (1..TOTAL_COLUMNS).to_a, allow_blank: true }

  def self.setup!
    return if Robot.count > 0

    Robot.create
  end

  def placed?
    row_position.present? && column_position.present? && direction.present?
  end
end
