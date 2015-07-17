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

ActiveRecord::Schema.define(version: 20150717082852) do

  create_table "api_keys", force: true do |t|
    t.integer  "list_id"
    t.string   "api_key"
    t.string   "email"
    t.boolean  "owner"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles", force: true do |t|
    t.integer  "list_id"
    t.string   "name"
    t.string   "qty"
    t.string   "category"
    t.string   "type"
    t.string   "shop"
    t.string   "prize"
    t.string   "checked"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lists", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "paymentIdentifier"
    t.string   "receipt"
  end

  add_index "lists", ["paymentIdentifier"], name: "index_lists_on_paymentIdentifier"

end
