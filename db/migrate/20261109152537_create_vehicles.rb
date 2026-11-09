class CreateVehicles < ActiveRecord::Migration[7.2]
  def change
    create_table :vehicles do |t|
      t.references :make, null: false, foreign_key: true
      t.string :model
      t.integer :model_year
      t.string :vehicle_type

      t.timestamps
    end
  end
end
