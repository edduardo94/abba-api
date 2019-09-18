class CreateLevels < ActiveRecord::Migration[5.2]
  def change
    create_table :levels do |t|
      t.column :title, :string, :null => false
      t.column :commission, :float, :null => false
      t.column :points, :float, :null => false
      t.integer :bonus_levels
      t.float :bonus_level_1
      t.float :bonus_level_2
      t.float :bonus_level_3
      t.float :bonus_level_4
      t.float :bonus_level_5
      t.column :kind, :string, :null => false
      t.column :active, :boolean, :null => false

      t.timestamps
      t.timestamp :deleted_at

      t.index [:kind, :active], unique: true, name: 'level_kind_index'
      t.index [:points, :active], unique: true, name: 'level_points_index'
    end
  end
end
