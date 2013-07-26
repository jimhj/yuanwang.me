class CreateWishes < ActiveRecord::Migration
  def change
    create_table :wishes, id: false do |t|
      t.column :id, "char(8)", null: false
      t.text :content, null: false
      t.string :photo
      t.string :status, null: false, limit: 80, defualt: "PENDING"
      t.datetime :deadline
      t.column :achiever_id, "char(8)"
      t.integer :wishers_count, default: 0      
      t.references :user
      t.timestamps
    end

    add_index :wishes, :user_id
  end
end
