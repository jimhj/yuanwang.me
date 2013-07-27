# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130726132822) do

  create_table "users", id: false, force: true do |t|
    t.string   "id",              limit: 8,               null: false
    t.string   "name",            limit: 40,              null: false
    t.string   "avatar"
    t.string   "email",           limit: 80, default: "", null: false
    t.string   "password_digest",            default: "", null: false
    t.string   "weibo_uid",       limit: 80
    t.string   "weibo_token",     limit: 80
    t.integer  "wishes_count",               default: 0
    t.string   "last_sign_in_ip", limit: 80
    t.datetime "last_sign_in_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "wishers", force: true do |t|
    t.integer  "user_id"
    t.integer  "wish_id"
    t.boolean  "current",    default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wishers", ["user_id"], name: "index_wishers_on_user_id", using: :btree
  add_index "wishers", ["wish_id"], name: "index_wishers_on_wish_id", using: :btree

  create_table "wishes", id: false, force: true do |t|
    t.string   "id",            limit: 8,              null: false
    t.text     "content",                              null: false
    t.string   "photo"
    t.string   "refer_link"
    t.datetime "deadline"
    t.string   "status",        limit: 80
    t.string   "achiever_id",   limit: 8
    t.integer  "wishers_count",            default: 0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wishes", ["user_id"], name: "index_wishes_on_user_id", using: :btree

end
