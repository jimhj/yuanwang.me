class CreateWishes < ActiveRecord::Migration
  def change
    create_table :wishes, id: false do |t|
      t.column :id, "char(8)", null: false
      t.text :content, null: false
      t.string :photo
      t.string :refer_link
      t.datetime :deadline      
      t.string :status, limit: 80, default: "PENDING"
      t.column :achiever_id, "char(8)"
      t.integer :wishers_count, default: 0      
      t.references :user
      t.timestamps
    end

    add_index :wishes, :user_id
  end
end
