class CreatePoints < ActiveRecord::Migration[5.2]
  def change
    create_table :points do |t|
      t.float :value
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
