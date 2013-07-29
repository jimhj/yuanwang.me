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

ActiveRecord::Schema.define(version: 20130729071243) do

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "notifications", force: true do |t|
    t.string   "user_id",    limit: 8,                  null: false
    t.string   "to_user_id", limit: 8,                  null: false
    t.string   "type",       limit: 80, default: "",    null: false
    t.string   "model_id",   limit: 8
    t.boolean  "readed",                default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["to_user_id", "readed"], name: "index_notifications_on_to_user_id_and_readed", using: :btree
  add_index "notifications", ["to_user_id"], name: "index_notifications_on_to_user_id", using: :btree
  add_index "notifications", ["user_id", "type"], name: "index_notifications_on_user_id_and_type", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

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
    t.string   "user_id",    limit: 8,                null: false
    t.string   "wish_id",    limit: 8,                null: false
    t.boolean  "current",              default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wishers", ["user_id"], name: "index_wishers_on_user_id", using: :btree
  add_index "wishers", ["wish_id"], name: "index_wishers_on_wish_id", using: :btree

  create_table "wishes", id: false, force: true do |t|
    t.string   "id",            limit: 8,                      null: false
    t.text     "content",                                      null: false
    t.string   "photo"
    t.string   "refer_link"
    t.datetime "deadline"
    t.string   "status",        limit: 80, default: "PENDING"
    t.string   "achiever_id",   limit: 8
    t.integer  "wishers_count",            default: 0
    t.string   "user_id",       limit: 8,                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wishes", ["user_id"], name: "index_wishes_on_user_id", using: :btree

end
