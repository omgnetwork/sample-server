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

ActiveRecord::Schema.define(version: 20_171_113_092_134) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'access_tokens', force: :cascade do |t|
    t.string 'token_digest'
    t.bigint 'user_id'
    t.bigint 'api_key_id'
    t.datetime 'accessed_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'omisego_authentication_token'
    t.index ['api_key_id'], name: 'index_access_tokens_on_api_key_id'
    t.index %w[user_id api_key_id], name: 'index_access_tokens_on_user_id_and_api_key_id',
                                    unique: true
    t.index ['user_id'], name: 'index_access_tokens_on_user_id'
  end

  create_table 'api_keys', force: :cascade do |t|
    t.string 'key'
    t.boolean 'active', default: true
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['key'], name: 'index_api_keys_on_key'
  end

  create_table 'products', force: :cascade do |t|
    t.string 'name', null: false
    t.text 'description'
    t.string 'image_url'
    t.integer 'price_satangs', default: 0, null: false
    t.string 'price_currency', default: 'THB', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'purchases', force: :cascade do |t|
    t.bigint 'product_id'
    t.bigint 'user_id'
    t.integer 'price_satangs', default: 0, null: false
    t.string 'price_currency', default: 'THB', null: false
    t.string 'idempotency_key'
    t.integer 'status', default: 0
    t.text 'error', default: '{}', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'token_value'
    t.string 'token_symbol'
    t.index ['product_id'], name: 'index_purchases_on_product_id'
    t.index %w[user_id product_id], name: 'index_purchases_on_user_id_and_product_id'
    t.index ['user_id'], name: 'index_purchases_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email'
    t.string 'password_digest'
    t.string 'first_name'
    t.string 'last_name'
    t.datetime 'last_logged_in_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_users_on_email'
  end

  add_foreign_key 'access_tokens', 'api_keys', on_delete: :cascade
  add_foreign_key 'access_tokens', 'users', on_delete: :cascade
  add_foreign_key 'purchases', 'products'
  add_foreign_key 'purchases', 'users'
end
