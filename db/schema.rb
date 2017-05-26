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

ActiveRecord::Schema.define(version: 20150918230101) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "gamekey"
    t.integer  "version",             default: 0
    t.string   "short_description"
    t.string   "version_description"
    t.string   "company"
    t.string   "apk_link"
    t.string   "logo"
    t.string   "image1"
    t.string   "image2"
    t.string   "image3"
    t.string   "image4"
    t.string   "image5"
    t.string   "image6"
    t.string   "image7"
    t.string   "image8"
    t.string   "image9"
    t.string   "image10"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games_packages", id: false, force: :cascade do |t|
    t.integer "package_id"
    t.integer "game_id"
  end

  add_index "games_packages", ["game_id"], name: "index_games_packages_on_game_id", using: :btree
  add_index "games_packages", ["package_id"], name: "index_games_packages_on_package_id", using: :btree

  create_table "packages", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "description"
    t.integer  "price"
    t.string   "logo"
  end

  create_table "providers", force: :cascade do |t|
    t.string   "email",                 default: "", null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "credit",                default: 0
    t.string   "api_token",  limit: 64
    t.string   "name"
  end

  add_index "providers", ["email"], name: "index_providers_on_email", unique: true, using: :btree

  create_table "sales", force: :cascade do |t|
    t.integer  "provider_id"
    t.integer  "package_id"
    t.integer  "sd_package_id"
    t.integer  "price"
    t.inet     "ip"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "sd_packages", force: :cascade do |t|
    t.string   "key"
    t.string   "tablet"
    t.integer  "provider_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "sd_packages", ["provider_id"], name: "index_sd_packages_on_provider_id", using: :btree

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "roles_mask"
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string  "foreign_key_name", null: false
    t.integer "foreign_key_id"
  end

  add_index "version_associations", ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key", using: :btree
  add_index "version_associations", ["version_id"], name: "index_version_associations_on_version_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.integer  "transaction_id"
    t.inet     "ip"
    t.string   "user_agent"
    t.integer  "ticket_id"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["transaction_id"], name: "index_versions_on_transaction_id", using: :btree

end
