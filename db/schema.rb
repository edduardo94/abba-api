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

ActiveRecord::Schema.define(version: 2019_08_14_222941) do

  create_table "activations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "status"
    t.bigint "user_id"
    t.string "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_activations_on_user_id"
  end

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "addresses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "cep"
    t.string "address"
    t.integer "number"
    t.string "neighborhood"
    t.string "city"
    t.string "complement"
    t.string "state"
    t.boolean "is_principal"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "bank_accounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.string "agency"
    t.string "account"
    t.string "bank_code"
    t.string "bank_name"
    t.string "operation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "cpf"
    t.index ["user_id"], name: "index_bank_accounts_on_user_id"
  end

  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "commissions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.decimal "value", precision: 15, scale: 2
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "commissions_user_id_index", unique: true
    t.index ["user_id"], name: "index_commissions_on_user_id"
  end

  create_table "grid_variations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.integer "grid_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "grids", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "grids_products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "grid_id"
    t.index ["grid_id"], name: "index_grids_products_on_grid_id"
    t.index ["product_id", "grid_id"], name: "grid_product_index", unique: true
    t.index ["product_id"], name: "index_grids_products_on_product_id"
  end

  create_table "levels", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", null: false
    t.float "commission", null: false
    t.float "points", null: false
    t.integer "bonus_levels"
    t.float "bonus_level_1"
    t.float "bonus_level_2"
    t.float "bonus_level_3"
    t.float "bonus_level_4"
    t.float "bonus_level_5"
    t.string "kind", null: false
    t.boolean "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.timestamp "deleted_at"
    t.index ["kind", "active"], name: "level_kind_index", unique: true
    t.index ["points", "active"], name: "level_points_index", unique: true
  end

  create_table "mercardo_pago_transactions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "date_created"
    t.string "mercado_pago_transaction_id"
    t.string "init_point"
    t.string "sandbox_init_point"
    t.string "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", id: :string, limit: 36, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.decimal "value", precision: 15, scale: 2
    t.bigint "user_id"
    t.decimal "frete_value", precision: 15, scale: 2
    t.integer "frete_days"
    t.string "frete_type"
    t.string "payment_type"
    t.integer "address_id"
    t.integer "status", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order_type"
    t.string "tracking_code"
    t.boolean "points_released"
    t.boolean "commission_released"
    t.integer "installments"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "orders_stocks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "stock_id"
    t.string "order_id"
    t.integer "quantity"
    t.bigint "product_id"
    t.decimal "value", precision: 15, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id", "stock_id", "product_id"], name: "variation_product_index", unique: true
    t.index ["order_id"], name: "index_orders_stocks_on_order_id"
    t.index ["product_id"], name: "index_orders_stocks_on_product_id"
    t.index ["stock_id"], name: "index_orders_stocks_on_stock_id"
  end

  create_table "pagar_me_transactions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "order_id"
    t.string "pagarme_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "paghiper_notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "notification_id"
    t.string "paghiper_transaction_id"
    t.timestamp "notification_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "paghiper_transactions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "transaction_id"
    t.integer "value_cents"
    t.string "status"
    t.string "order_id"
    t.date "due_date"
    t.string "digitable_line"
    t.string "url_slip"
    t.string "url_slip_pdf"
    t.timestamp "created_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "points", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.decimal "value", precision: 15, scale: 2
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "networking_points", precision: 15, scale: 2
    t.index ["user_id"], name: "index_points_on_user_id"
    t.index ["user_id"], name: "user_id_index", unique: true
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "description"
    t.integer "product_type"
    t.decimal "price", precision: 15, scale: 2
    t.decimal "office_price", precision: 15, scale: 2
    t.integer "category_id"
    t.integer "subcategory_id"
    t.boolean "active"
    t.float "unity_price"
    t.decimal "promotional_price", precision: 15, scale: 2
    t.float "weight"
    t.integer "width"
    t.integer "height"
    t.integer "depth"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "favorite"
  end

  create_table "stocks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "product_id"
    t.string "size"
    t.integer "quantity"
    t.integer "grid_variation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "grid_variation_id"], name: "product_variation_index", unique: true
  end

  create_table "subcategories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "cpf"
    t.string "gender"
    t.string "birth_date"
    t.string "cellphone"
    t.string "phone"
    t.integer "user_type", default: 1
    t.integer "host_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "level_id"
    t.index ["email"], name: "user_email_index", unique: true
    t.index ["level_id"], name: "index_users_on_level_id"
  end

  create_table "wallets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.decimal "value", precision: 15, scale: 2
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wallets_on_user_id"
    t.index ["user_id"], name: "wallets_user_id_index", unique: true
  end

  create_table "withdrawals", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.decimal "value", precision: 15, scale: 2
    t.bigint "user_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bank_account_id"
    t.index ["user_id"], name: "index_withdrawals_on_user_id"
  end

  add_foreign_key "activations", "users"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bank_accounts", "users"
  add_foreign_key "commissions", "users"
  add_foreign_key "points", "users"
  add_foreign_key "users", "levels"
  add_foreign_key "wallets", "users"
  add_foreign_key "withdrawals", "users"
end
