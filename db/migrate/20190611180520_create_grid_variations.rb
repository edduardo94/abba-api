class CreateGridVariations < ActiveRecord::Migration[5.2]
  def change
    create_table :grid_variations do |t|
      t.string :name
      t.integer :grid_id
      t.timestamps
    end
  end
end
