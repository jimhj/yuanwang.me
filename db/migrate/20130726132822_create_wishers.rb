class CreateWishers < ActiveRecord::Migration
  def change
    create_table :wishers do |t|
      t.column :user_id, "char(8)", null: false
      t.column :wish_id, "char(8)", null: false
      t.boolean :current, default: true
      t.timestamps
    end

    add_index :wishers, :user_id
    add_index :wishers, :wish_id
  end
end
