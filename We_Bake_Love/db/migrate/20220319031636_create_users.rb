class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :role, default: "user"
      t.string :phone
      t.text :address
      t.timestamps
    end
  end
end
