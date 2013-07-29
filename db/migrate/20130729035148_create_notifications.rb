class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.column :user_id, "char(8)", null: false
      t.column :to_user_id, "char(8)", null: false
      t.string :type, :null => false, :limit => 80, :default => ""
      t.column :model_id, "char(8)"
      t.boolean :readed, :default => false, :null => false
      t.timestamps
    end

    add_index :notifications, :user_id
    add_index :notifications, [:user_id, :type]
    add_index :notifications, :to_user_id
    add_index :notifications, [:to_user_id, :readed]
  end
end
