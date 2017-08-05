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

ActiveRecord::Schema.define(version: 20170803055956) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "allowances", force: :cascade do |t|
    t.decimal  "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order_id"
    t.index ["order_id"], name: "index_allowances_on_order_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string   "category_name"
    t.boolean  "status"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "dishes", force: :cascade do |t|
    t.string   "description"
    t.string   "dish_name"
    t.string   "dish_name_not_mark"
    t.string   "image"
    t.boolean  "status"
    t.boolean  "is_available",       default: true
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "category_id"
    t.integer  "material_id"
    t.index ["category_id"], name: "index_dishes_on_category_id", using: :btree
    t.index ["material_id"], name: "index_dishes_on_material_id", using: :btree
  end

  create_table "materials", force: :cascade do |t|
    t.string   "name"
    t.boolean  "available",  default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "order_details", force: :cascade do |t|
    t.decimal  "price",                precision: 20, scale: 2
    t.float    "discount_rate_by_day"
    t.integer  "quantity"
    t.integer  "quantity_not_serve"
    t.integer  "quantity_not_served"
    t.integer  "order_id"
    t.boolean  "status"
    t.integer  "cooking_status",                                default: 0
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.integer  "dish_id"
    t.index ["dish_id"], name: "index_order_details_on_dish_id", using: :btree
    t.index ["order_id"], name: "index_order_details_on_order_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.decimal  "total",                       precision: 20, scale: 2
    t.string   "discount_date_by_membership"
    t.integer  "user_id"
    t.integer  "table_number"
    t.string   "payment_id"
    t.boolean  "status"
    t.integer  "cooking_status",                                       default: 0
    t.integer  "payment_method",                                       default: 0
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
    t.index ["user_id"], name: "index_orders_on_user_id", using: :btree
  end

  create_table "price_change_histories", force: :cascade do |t|
    t.integer  "dish_id"
    t.decimal  "price",      precision: 20, scale: 2
    t.datetime "from_date"
    t.boolean  "status"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["dish_id"], name: "index_price_change_histories_on_dish_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.boolean  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tables", force: :cascade do |t|
    t.integer  "table_number"
    t.boolean  "status"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "user_vouchers", force: :cascade do |t|
    t.integer "user_id"
    t.integer "voucher_id"
    t.index ["user_id"], name: "index_user_vouchers_on_user_id", using: :btree
    t.index ["voucher_id"], name: "index_user_vouchers_on_voucher_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ipd"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,       null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "full_name"
    t.string   "avatar"
    t.string   "email"
    t.string   "username"
    t.string   "access_token"
    t.string   "reg_token"
    t.string   "birthdate"
    t.float    "mark",                   default: 0.0
    t.string   "phone"
    t.json     "tokens"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "role_id"
    t.decimal  "balance",                default: "0.0"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["role_id"], name: "index_users_on_role_id", using: :btree
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", using: :btree
  end

  create_table "vouchers", force: :cascade do |t|
    t.decimal  "total"
    t.string   "code"
    t.boolean  "status",     default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_foreign_key "allowances", "orders"
  add_foreign_key "dishes", "categories"
  add_foreign_key "dishes", "materials"
  add_foreign_key "order_details", "dishes"
  add_foreign_key "orders", "users"
  add_foreign_key "price_change_histories", "dishes"
  add_foreign_key "user_vouchers", "users"
  add_foreign_key "user_vouchers", "vouchers"
  add_foreign_key "users", "roles"
end
