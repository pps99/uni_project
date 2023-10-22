class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.string :message
      t.boolean :read, default: false
      t.timestamps
    end
  end
end
