class AddIdempotencyTokenToPurchases < ActiveRecord::Migration[5.1]
  def change
    remove_column :purchases, :idempotency_key
    add_column :purchases, :idempotency_token, :string, null: false
    add_index :purchases, :idempotency_token, unique: true
  end
end
