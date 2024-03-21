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

ActiveRecord::Schema[7.1].define(version: 2023_11_29_174622) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
    t.index ["record_type", "record_id"], name: "index_active_storage_attachments_on_record_type_and_record_id"
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
    t.index ["blob_id"], name: "index_active_storage_variant_records_on_blob_id"
  end

  create_table "addresses", force: :cascade do |t|
    t.string "name"
    t.string "line_one"
    t.string "line_two"
    t.string "line_three"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.float "latitude"
    t.float "longitude"
    t.boolean "default", default: false
    t.bigint "organization_id"
    t.bigint "user_id"
    t.bigint "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["latitude"], name: "index_addresses_on_latitude"
    t.index ["location_id"], name: "index_addresses_on_location_id"
    t.index ["longitude"], name: "index_addresses_on_longitude"
    t.index ["organization_id"], name: "index_addresses_on_organization_id"
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "apps", force: :cascade do |t|
    t.string "template"
    t.boolean "published", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.text "description"
    t.jsonb "metadata", default: {}
  end

  create_table "carts", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "draft_orders_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.jsonb "health", default: {}, null: false
    t.integer "items_count", default: 0
    t.integer "menus_count", default: 0
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "square_id"
    t.index ["organization_id"], name: "index_categories_on_organization_id"
    t.index ["square_id"], name: "index_categories_on_square_id", unique: true
  end

  create_table "category_items", force: :cascade do |t|
    t.integer "position", default: 0, null: false
    t.bigint "category_id", null: false
    t.bigint "item_id", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_category_items_on_category_id"
    t.index ["item_id"], name: "index_category_items_on_item_id"
    t.index ["organization_id"], name: "index_category_items_on_organization_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.jsonb "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state", default: "pending", null: false
    t.string "handler", null: false
  end

  create_table "feedbacks", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "user_id"
    t.text "content"
    t.integer "rating", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "order_user_id"
    t.bigint "order_id"
    t.bigint "location_id"
    t.boolean "notify", default: false
    t.text "response"
    t.index ["deleted_at"], name: "index_feedbacks_on_deleted_at"
    t.index ["location_id"], name: "index_feedbacks_on_location_id"
    t.index ["order_id"], name: "index_feedbacks_on_order_id"
    t.index ["order_user_id"], name: "index_feedbacks_on_order_user_id"
    t.index ["organization_id"], name: "index_feedbacks_on_organization_id"
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "integrations", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "type", null: false
    t.jsonb "configs", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "app_id"
    t.index ["app_id"], name: "index_integrations_on_app_id"
    t.index ["organization_id"], name: "index_integrations_on_organization_id"
  end

  create_table "item_modifiers", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "modifier_id", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_item_modifiers_on_item_id"
    t.index ["modifier_id"], name: "index_item_modifiers_on_modifier_id"
    t.index ["organization_id"], name: "index_item_modifiers_on_organization_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "price_cents", default: 0
    t.string "currency", default: "CAD", null: false
    t.boolean "sold_out", default: false, null: false
    t.string "source", null: false
    t.string "internal_tags", default: [], array: true
    t.jsonb "metadata", default: {}, null: false
    t.integer "menus_count", default: 0, null: false
    t.integer "modifiers_count", default: 0, null: false
    t.datetime "deleted_at"
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "square_id"
    t.string "unit", default: "ea", null: false
    t.index ["organization_id"], name: "index_items_on_organization_id"
  end

  create_table "location_menus", force: :cascade do |t|
    t.bigint "location_id", null: false
    t.bigint "menu_id", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 0, null: false
    t.index ["location_id"], name: "index_location_menus_on_location_id"
    t.index ["menu_id"], name: "index_location_menus_on_menu_id"
    t.index ["organization_id"], name: "index_location_menus_on_organization_id"
  end

  create_table "location_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.jsonb "metadata", default: {}
    t.integer "sort_key", null: false
    t.integer "location_id", null: false
    t.boolean "most_recent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id", "most_recent"], name: "index_location_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["location_id", "sort_key"], name: "index_location_transitions_parent_sort", unique: true
  end

  create_table "locations", force: :cascade do |t|
    t.string "name", null: false
    t.string "location_type", null: false
    t.string "phone"
    t.string "email"
    t.string "timezone", default: "Eastern Time (US & Canada)", null: false
    t.jsonb "schedule", default: {}
    t.string "pickup_instructions"
    t.decimal "tax_rate", precision: 8, scale: 2, null: false
    t.string "currency", null: false
    t.integer "expected_preparation_time_seconds", default: 0, null: false
    t.jsonb "health", default: {}, null: false
    t.integer "menus_count", default: 0, null: false
    t.boolean "auto_accept_order", default: false, null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "square_id"
    t.integer "feedbacks_count", default: 0, null: false
    t.decimal "rating", precision: 4, scale: 2, default: "0.0", null: false
    t.integer "tables_count", default: 0, null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_locations_on_deleted_at"
    t.index ["organization_id"], name: "index_locations_on_organization_id"
  end

  create_table "logs", force: :cascade do |t|
    t.jsonb "data", default: {}, null: false
    t.string "message_key", null: false
    t.string "scope", null: false
    t.bigint "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "qr_code_id"
    t.index ["order_id"], name: "index_logs_on_order_id"
    t.index ["qr_code_id"], name: "index_logs_on_qr_code_id"
  end

  create_table "menu_categories", force: :cascade do |t|
    t.bigint "menu_id", null: false
    t.bigint "category_id", null: false
    t.boolean "published", default: false, null: false
    t.integer "items_count", default: 0, null: false
    t.integer "position", default: 0, null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_menu_categories_on_category_id"
    t.index ["menu_id", "category_id"], name: "index_menu_categories_on_menu_id_and_category_id", unique: true
    t.index ["menu_id"], name: "index_menu_categories_on_menu_id"
    t.index ["organization_id"], name: "index_menu_categories_on_organization_id"
  end

  create_table "menu_category_items", force: :cascade do |t|
    t.bigint "menu_category_id", null: false
    t.bigint "item_id", null: false
    t.integer "position", default: 0, null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_menu_category_items_on_item_id"
    t.index ["menu_category_id", "item_id"], name: "index_menu_category_items_on_menu_category_id_and_item_id", unique: true
    t.index ["menu_category_id"], name: "index_menu_category_items_on_menu_category_id"
    t.index ["organization_id"], name: "index_menu_category_items_on_organization_id"
  end

  create_table "menus", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.jsonb "schedule", default: {}
    t.boolean "published", default: false, null: false
    t.integer "items_count", default: 0, null: false
    t.integer "active_items_count", default: 0, null: false
    t.integer "categories_count", default: 0, null: false
    t.integer "locations_count", default: 0, null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_menus_on_organization_id"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "first_name", default: ""
    t.string "last_name", default: ""
    t.date "dob"
    t.string "email", default: ""
    t.string "phone", default: ""
    t.string "encrypted_password", default: ""
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "stripe_person_id", default: ""
    t.string "color"
    t.string "role", null: false
    t.jsonb "policies", default: {}, null: false
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "stripe_customer_id"
    t.index ["email"], name: "index_merchants_on_email"
    t.index ["invitation_token"], name: "index_merchants_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_merchants_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["organization_id"], name: "index_merchants_on_organization_id"
    t.index ["phone"], name: "index_merchants_on_phone"
    t.index ["stripe_customer_id"], name: "index_merchants_on_stripe_customer_id"
  end

  create_table "modifiers", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "required", default: false
    t.integer "min_select", default: 0
    t.integer "max_select", default: 1
    t.integer "max_option_select", default: 1
    t.integer "options_count", default: 0
    t.integer "items_count", default: 0
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "square_id"
    t.index ["organization_id"], name: "index_modifiers_on_organization_id"
    t.index ["square_id"], name: "index_modifiers_on_square_id", unique: true
  end

  create_table "notes", force: :cascade do |t|
    t.text "body"
    t.string "notable_type", null: false
    t.bigint "notable_id", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notable_type", "notable_id"], name: "index_notes_on_notable"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.string "type", null: false
    t.jsonb "params"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["read_at"], name: "index_notifications_on_read_at"
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient"
  end

  create_table "onboarding_tasks", force: :cascade do |t|
    t.bigint "onboarding_id", null: false
    t.string "template", null: false
    t.string "category", null: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["onboarding_id"], name: "index_onboarding_tasks_on_onboarding_id"
  end

  create_table "onboarding_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.jsonb "metadata", default: {}
    t.integer "sort_key", null: false
    t.integer "onboarding_id", null: false
    t.boolean "most_recent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["onboarding_id", "most_recent"], name: "index_onboarding_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["onboarding_id", "sort_key"], name: "index_onboarding_transitions_parent_sort", unique: true
  end

  create_table "onboardings", force: :cascade do |t|
    t.bigint "organization_id"
    t.string "status", default: "active", null: false
    t.integer "tasks_count", default: 0, null: false
    t.integer "completed_tasks_count", default: 0, null: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_onboardings_on_organization_id"
  end

  create_table "operations", force: :cascade do |t|
    t.string "name"
    t.string "status"
    t.jsonb "params"
    t.jsonb "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "options", force: :cascade do |t|
    t.integer "position", default: 0, null: false
    t.bigint "option_id"
    t.bigint "modifier_id"
    t.bigint "item_id"
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_options_on_item_id"
    t.index ["modifier_id"], name: "index_options_on_modifier_id"
    t.index ["option_id"], name: "index_options_on_option_id"
    t.index ["organization_id"], name: "index_options_on_organization_id"
  end

  create_table "order_item_modifiers", force: :cascade do |t|
    t.bigint "order_item_id", null: false
    t.bigint "modifier_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["modifier_id"], name: "index_order_item_modifiers_on_modifier_id"
    t.index ["order_item_id"], name: "index_order_item_modifiers_on_order_item_id"
  end

  create_table "order_item_options", force: :cascade do |t|
    t.bigint "order_item_modifier_id", null: false
    t.bigint "option_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_cents", default: 0, null: false
    t.string "currency", default: "CAD", null: false
    t.index ["option_id"], name: "index_order_item_options_on_option_id"
    t.index ["order_item_modifier_id"], name: "index_order_item_options_on_order_item_modifier_id"
    t.index ["price_cents"], name: "index_order_item_options_on_price_cents"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "quantity", default: 1, null: false
    t.bigint "order_id", null: false
    t.bigint "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_cents", default: 0, null: false
    t.string "currency", default: "CAD", null: false
    t.integer "modifiers_count", default: 0, null: false
    t.string "status", default: "paid", null: false
    t.index ["item_id"], name: "index_order_items_on_item_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "order_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.jsonb "metadata", default: {}
    t.integer "sort_key", null: false
    t.integer "order_id", null: false
    t.boolean "most_recent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id", "most_recent"], name: "index_order_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["order_id", "sort_key"], name: "index_order_transitions_parent_sort", unique: true
  end

  create_table "order_users", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "user_id"
    t.string "name"
    t.string "email"
    t.string "phone"
    t.integer "paying_for"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 0, null: false
    t.index ["order_id"], name: "index_order_users_on_order_id"
    t.index ["user_id"], name: "index_order_users_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "status", null: false
    t.string "preference", null: false
    t.string "platform", null: false
    t.string "number"
    t.string "tracking_token"
    t.integer "preparation_time_seconds", default: 0, null: false
    t.datetime "scheduled_for"
    t.datetime "submitted_at"
    t.datetime "in_progress_at"
    t.datetime "ready_at"
    t.datetime "completed_at"
    t.datetime "cancelled_at"
    t.integer "items_count", default: 0, null: false
    t.integer "payments_count", default: 0, null: false
    t.integer "feedbacks_count", default: 0, null: false
    t.bigint "organization_id", null: false
    t.bigint "location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.bigint "cart_id"
    t.string "square_id"
    t.string "receipt_number"
    t.bigint "table_id"
    t.integer "added_items_count", default: 0, null: false
    t.string "payment_split_type"
    t.integer "number_of_people", default: 1
    t.string "clover_id"
    t.index ["cart_id"], name: "index_orders_on_cart_id"
    t.index ["clover_id"], name: "index_orders_on_clover_id"
    t.index ["discarded_at"], name: "index_orders_on_discarded_at"
    t.index ["location_id"], name: "index_orders_on_location_id"
    t.index ["organization_id"], name: "index_orders_on_organization_id"
    t.index ["table_id"], name: "index_orders_on_table_id"
  end

  create_table "organization_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.jsonb "metadata", default: {}
    t.integer "sort_key", null: false
    t.integer "organization_id", null: false
    t.boolean "most_recent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "most_recent"], name: "index_organization_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["organization_id", "sort_key"], name: "index_organization_transitions_parent_sort", unique: true
  end

  create_table "organizations", force: :cascade do |t|
    t.string "legal_name"
    t.string "name", null: false
    t.string "nickname"
    t.string "status", null: false
    t.string "description"
    t.string "business_number"
    t.string "currency", null: false
    t.string "email"
    t.string "phone"
    t.string "website"
    t.string "business_category", null: false
    t.string "business_type", null: false
    t.string "stripe_customer_id"
    t.string "stripe_account_id"
    t.text "product_details"
    t.jsonb "health", default: {}, null: false
    t.integer "feedbacks_count", default: 0, null: false
    t.integer "unread_notifications_count", default: 0, null: false
    t.boolean "payouts_enabled", default: false, null: false
    t.boolean "charges_enabled", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "owner_id", null: false
    t.string "square_id"
    t.boolean "details_submitted", default: false
    t.string "application_fee_type"
    t.decimal "application_fee_rate", precision: 5, scale: 2
    t.string "application_fee_math", null: false
    t.string "clover_id"
    t.index ["name"], name: "index_organizations_on_name"
    t.index ["nickname"], name: "index_organizations_on_nickname"
    t.index ["owner_id"], name: "index_organizations_on_owner_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.bigint "organization_id"
    t.bigint "user_id"
    t.string "processor_id", null: false
    t.boolean "default", default: false, null: false
    t.string "source_type"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_payment_methods_on_organization_id"
    t.index ["processor_id"], name: "index_payment_methods_on_processor_id"
    t.index ["user_id"], name: "index_payment_methods_on_user_id"
  end

  create_table "payment_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.jsonb "metadata", default: {}
    t.integer "sort_key", null: false
    t.integer "payment_id", null: false
    t.boolean "most_recent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payment_id", "most_recent"], name: "index_payment_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["payment_id", "sort_key"], name: "index_payment_transitions_parent_sort", unique: true
  end

  create_table "payments", force: :cascade do |t|
    t.string "stripe_payment_intent_id"
    t.string "status", null: false
    t.string "currency", default: "CAD", null: false
    t.integer "amount_cents", default: 0, null: false
    t.jsonb "latest_charge_data", default: {}, null: false
    t.datetime "cancelled_at"
    t.datetime "refunded_at"
    t.datetime "failed_at"
    t.datetime "paid_at"
    t.bigint "order_id"
    t.bigint "user_id"
    t.bigint "payment_method_id"
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "square_id"
    t.bigint "order_user_id"
    t.integer "subtotal_cents", default: 0
    t.integer "tax_cents", default: 0
    t.integer "tip_cents", default: 0
    t.integer "application_fee_cents", default: 0
    t.integer "application_fee_tax_cents", default: 0
    t.string "application_fee_math"
    t.index ["order_id"], name: "index_payments_on_order_id"
    t.index ["order_user_id"], name: "index_payments_on_order_user_id"
    t.index ["organization_id"], name: "index_payments_on_organization_id"
    t.index ["payment_method_id"], name: "index_payments_on_payment_method_id"
    t.index ["stripe_payment_intent_id"], name: "index_payments_on_stripe_payment_intent_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "payout_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.jsonb "metadata", default: {}
    t.integer "sort_key", null: false
    t.integer "payout_id", null: false
    t.boolean "most_recent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payout_id", "most_recent"], name: "index_payout_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["payout_id", "sort_key"], name: "index_payout_transitions_parent_sort", unique: true
  end

  create_table "payouts", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "payment_method_id", null: false
    t.string "stripe_payout_id", null: false
    t.integer "amount_cents"
    t.string "currency", default: "CAD", null: false
    t.jsonb "data"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_payouts_on_organization_id"
    t.index ["payment_method_id"], name: "index_payouts_on_payment_method_id"
    t.index ["stripe_payout_id"], name: "index_payouts_on_stripe_payout_id"
  end

  create_table "qr_codes", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "location_id"
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "table_id"
    t.index ["location_id"], name: "index_qr_codes_on_location_id"
    t.index ["organization_id"], name: "index_qr_codes_on_organization_id"
    t.index ["table_id"], name: "index_qr_codes_on_table_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "organization_id"
    t.string "status"
    t.string "interval"
    t.string "stripe_plan_id"
    t.string "stripe_customer_id"
    t.string "stripe_subscription_id"
    t.integer "quantity"
    t.datetime "canceled_at"
    t.datetime "trial_starts_at"
    t.datetime "trial_ends_at"
    t.datetime "ends_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_subscriptions_on_organization_id"
  end

  create_table "suggestions", force: :cascade do |t|
    t.integer "user_id"
    t.text "description"
    t.string "referer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "merchant_id"
    t.jsonb "data", default: {}, null: false
    t.index ["merchant_id"], name: "index_suggestions_on_merchant_id"
    t.index ["user_id"], name: "index_suggestions_on_user_id"
  end

  create_table "tables", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "location_id", null: false
    t.string "name"
    t.integer "position", default: 0
    t.integer "capacity"
    t.string "square_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_tables_on_location_id"
    t.index ["organization_id"], name: "index_tables_on_organization_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", default: ""
    t.string "last_name", default: ""
    t.date "dob"
    t.string "phone"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "stripe_customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.datetime "created_at"
    t.jsonb "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "webhooks", force: :cascade do |t|
    t.string "source"
    t.string "data_type"
    t.jsonb "data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "categories", "organizations"
  add_foreign_key "category_items", "categories"
  add_foreign_key "category_items", "items"
  add_foreign_key "category_items", "organizations"
  add_foreign_key "integrations", "apps"
  add_foreign_key "integrations", "organizations"
  add_foreign_key "item_modifiers", "items"
  add_foreign_key "item_modifiers", "modifiers"
  add_foreign_key "item_modifiers", "organizations"
  add_foreign_key "items", "organizations"
  add_foreign_key "location_menus", "locations"
  add_foreign_key "location_menus", "menus"
  add_foreign_key "location_menus", "organizations"
  add_foreign_key "location_transitions", "locations"
  add_foreign_key "locations", "organizations"
  add_foreign_key "menu_categories", "categories"
  add_foreign_key "menu_categories", "menus"
  add_foreign_key "menu_categories", "organizations"
  add_foreign_key "menu_category_items", "items"
  add_foreign_key "menu_category_items", "menu_categories"
  add_foreign_key "menu_category_items", "organizations"
  add_foreign_key "menus", "organizations"
  add_foreign_key "merchants", "organizations"
  add_foreign_key "modifiers", "organizations"
  add_foreign_key "notes", "merchants", column: "user_id"
  add_foreign_key "onboarding_tasks", "onboardings"
  add_foreign_key "onboarding_transitions", "onboardings"
  add_foreign_key "options", "organizations"
  add_foreign_key "order_item_modifiers", "modifiers"
  add_foreign_key "order_item_modifiers", "order_items"
  add_foreign_key "order_item_options", "options"
  add_foreign_key "order_item_options", "order_item_modifiers"
  add_foreign_key "order_items", "items"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_transitions", "orders"
  add_foreign_key "order_users", "merchants", column: "user_id"
  add_foreign_key "order_users", "orders"
  add_foreign_key "orders", "carts"
  add_foreign_key "organization_transitions", "organizations"
  add_foreign_key "organizations", "merchants", column: "owner_id"
  add_foreign_key "payment_transitions", "payments"
  add_foreign_key "payments", "order_users"
  add_foreign_key "payout_transitions", "payouts"
  add_foreign_key "qr_codes", "organizations"
  add_foreign_key "subscriptions", "organizations"
end
