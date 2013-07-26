class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: false do |t|
      t.column :id, "char(8)", null: false, defualt: ""
      t.string :name, limit: 40, null: false, defualt: ""
      t.string :avatar, defualt: ""
      t.string :email, null: false, unique: true, default: "", limit: 80
      t.string :password_digest, null: false, default: ""
      t.string :weibo_uid, limit: 80
      t.string :weibo_token, limit: 80 
      t.integer :wishes_count, default: 0
      t.string :last_sign_in_ip, limit: 80
      t.datetime :last_sign_in_at      
      t.timestamps
    end

    add_index :users, :email, :unique => true
  end
end
