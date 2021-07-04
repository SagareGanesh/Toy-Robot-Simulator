class CreateRobots < ActiveRecord::Migration[6.1]
  def change
    create_table :robots do |t|
      t.string :direction
      t.integer :row_position
      t.integer :column_position
    end
  end
end
