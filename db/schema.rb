# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_11_154924) do
  create_table "additionals", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
  end

  create_table "cash_registers", force: :cascade do |t|
    t.datetime "closed_at"
    t.decimal "closing_balance", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.text "observations"
    t.datetime "opened_at", null: false
    t.decimal "opening_balance", precision: 10, scale: 2, null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_cash_registers_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "customers", force: :cascade do |t|
    t.text "address"
    t.string "cpf_cnpj"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "neighborhood"
    t.text "notes"
    t.string "phone", null: false
    t.string "reference_point"
    t.datetime "updated_at", null: false
    t.index ["cpf_cnpj"], name: "index_customers_on_cpf_cnpj"
  end

  create_table "delivery_people", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "phone", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dining_tables", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "number", null: false
    t.integer "seats", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["number"], name: "index_dining_tables_on_number", unique: true
  end

  create_table "flavors", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "description"
    t.string "ingredients"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_flavors_on_name", unique: true
  end

  create_table "order_item_additionals", force: :cascade do |t|
    t.integer "additional_id", null: false
    t.datetime "created_at", null: false
    t.integer "order_item_id", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["additional_id"], name: "index_order_item_additionals_on_additional_id"
    t.index ["order_item_id"], name: "index_order_item_additionals_on_order_item_id"
  end

  create_table "order_item_flavors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "flavor_id", null: false
    t.integer "order_item_id", null: false
    t.datetime "updated_at", null: false
    t.index ["flavor_id"], name: "index_order_item_flavors_on_flavor_id"
    t.index ["order_item_id"], name: "index_order_item_flavors_on_order_item_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "discount", precision: 10, scale: 2, default: "0.0", null: false
    t.text "observation"
    t.integer "order_id", null: false
    t.integer "product_id", null: false
    t.integer "product_size_id"
    t.decimal "quantity", precision: 10, scale: 3, null: false
    t.decimal "total", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
    t.index ["product_size_id"], name: "index_order_items_on_product_size_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "cash_register_id", null: false
    t.datetime "created_at", null: false
    t.integer "customer_id"
    t.text "delivery_address"
    t.decimal "delivery_fee", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "delivery_person_id"
    t.integer "dining_table_id"
    t.decimal "discount", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "estimated_delivery_at"
    t.text "notes"
    t.string "number", null: false
    t.integer "order_type", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.decimal "subtotal", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["cash_register_id"], name: "index_orders_on_cash_register_id"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["delivery_person_id"], name: "index_orders_on_delivery_person_id"
    t.index ["dining_table_id"], name: "index_orders_on_dining_table_id"
    t.index ["number"], name: "index_orders_on_number", unique: true
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.decimal "change_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.integer "order_id", null: false
    t.integer "payment_method", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payments_on_order_id"
  end

  create_table "product_sizes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "max_flavors", default: 1, null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.integer "product_id", null: false
    t.string "size_name", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_sizes_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "barcode"
    t.decimal "base_price", precision: 10, scale: 2
    t.integer "category_id", null: false
    t.decimal "cost_price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.decimal "current_stock", precision: 10, scale: 3, default: "0.0", null: false
    t.string "description", null: false
    t.boolean "is_pizza", default: false, null: false
    t.decimal "min_stock", precision: 10, scale: 3, default: "0.0", null: false
    t.string "name", null: false
    t.string "sku"
    t.string "unit", default: "un", null: false
    t.datetime "updated_at", null: false
    t.index ["barcode"], name: "index_products_on_barcode", unique: true
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["sku"], name: "index_products_on_sku", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "stock_movements", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "current_stock", precision: 10, scale: 3, null: false
    t.integer "movement_type", null: false
    t.text "notes"
    t.decimal "previous_stock", precision: 10, scale: 3, null: false
    t.integer "product_id", null: false
    t.decimal "quantity", precision: 10, scale: 3, null: false
    t.string "reference"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["product_id"], name: "index_stock_movements_on_product_id"
    t.index ["user_id"], name: "index_stock_movements_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "name"
    t.string "password_digest", null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "cash_registers", "users"
  add_foreign_key "order_item_additionals", "additionals"
  add_foreign_key "order_item_additionals", "order_items"
  add_foreign_key "order_item_flavors", "flavors"
  add_foreign_key "order_item_flavors", "order_items"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "product_sizes"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "cash_registers"
  add_foreign_key "orders", "customers"
  add_foreign_key "orders", "delivery_people"
  add_foreign_key "orders", "dining_tables"
  add_foreign_key "orders", "users"
  add_foreign_key "payments", "orders"
  add_foreign_key "product_sizes", "products"
  add_foreign_key "products", "categories"
  add_foreign_key "sessions", "users"
  add_foreign_key "stock_movements", "products"
  add_foreign_key "stock_movements", "users"
end
