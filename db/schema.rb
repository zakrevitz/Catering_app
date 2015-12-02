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

ActiveRecord::Schema.define(version: 20151202193529) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "assets", force: :cascade do |t|
    t.integer  "assetable_id"
    t.string   "assetable_type"
    t.text     "filename"
    t.string   "type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "assets", ["assetable_type", "assetable_id"], name: "index_assets_on_assetable_type_and_assetable_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.text     "title",      null: false
    t.integer  "sort_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "daily_menus", force: :cascade do |t|
    t.integer  "day_number",                 null: false
    t.float    "max_total",  default: 100.0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "dish_ids",   default: [],                 array: true
    t.boolean  "active",     default: false
  end

  create_table "daily_rations", force: :cascade do |t|
    t.integer  "sprint_id"
    t.integer  "user_id"
    t.integer  "daily_menu_id"
    t.integer  "dish_id"
    t.float    "price",                      null: false
    t.integer  "quantity",       default: 1, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "dish_option_id"
  end

  add_index "daily_rations", ["daily_menu_id"], name: "index_daily_rations_on_daily_menu_id", using: :btree
  add_index "daily_rations", ["dish_id"], name: "index_daily_rations_on_dish_id", using: :btree
  add_index "daily_rations", ["dish_option_id"], name: "index_daily_rations_on_dish_option_id", using: :btree
  add_index "daily_rations", ["sprint_id"], name: "index_daily_rations_on_sprint_id", using: :btree
  add_index "daily_rations", ["user_id"], name: "index_daily_rations_on_user_id", using: :btree

  create_table "dish_options", force: :cascade do |t|
    t.integer  "dish_with_option_id"
    t.text     "title",               null: false
    t.float    "price",               null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "dish_options", ["dish_with_option_id"], name: "index_dish_options_on_dish_with_option_id", using: :btree

  create_table "dishes", force: :cascade do |t|
    t.integer  "category_id"
    t.text     "title",                                null: false
    t.text     "description"
    t.float    "price"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "type",         limit: 45
    t.integer  "children_ids",            default: [],              array: true
  end

  add_index "dishes", ["category_id"], name: "index_dishes_on_category_id", using: :btree
  add_index "dishes", ["children_ids"], name: "index_dishes_on_children_ids", using: :gin

  create_table "sprints", force: :cascade do |t|
    t.text     "title",       null: false
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "aasm_state"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "admin"
    t.integer  "favourite_dishes_id",    default: [],              array: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "daily_rations", "dish_options"
end
