class CreateTransitions < ActiveRecord::Migration[6.1]
  def change
    create_table :transitions do |t|
      t.string :user_id
      t.integer :amount, default: 0
      t.integer :recharge_amount, default: 0
      t.string :transition_no, default: 'nil'
      t.timestamps
    end
  end
end
