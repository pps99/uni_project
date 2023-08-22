class CreateTransitions < ActiveRecord::Migration[6.1]
  def change
    create_table :transitions do |t|
      t.string :user_id
      t.string :amount, default: "0"
      t.timestamps
    end
  end
end
