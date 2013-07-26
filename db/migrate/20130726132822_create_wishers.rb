class CreateWishers < ActiveRecord::Migration
  def change
    create_table :wishers do |t|
      t.references :user
      t.references :wish
      t.boolean :current, default: true
      t.timestamps
    end

    add_index :wishers, :user_id
    add_index :wishers, :wish_id
  end
end
