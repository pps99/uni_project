class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.string :name
      t.string :phone
      t.string :address
      t.integer :total
      t.string :option
      t.string :status, default: "pending"
      t.timestamps
    end
  end
end
