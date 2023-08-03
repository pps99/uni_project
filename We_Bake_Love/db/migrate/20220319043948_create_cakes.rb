class CreateCakes < ActiveRecord::Migration[6.1]
  def change
    create_table :cakes do |t|
      t.string :image
      t.string :name
      t.string :description
      t.string :type_name
      t.integer :price
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
