class CreatePurchases < ActiveRecord::Migration[5.1]
  def change
    create_table :purchases do |t|
      t.references :product, foreign_key: true, index: true
      t.references :user, foreign_key: true
      t.monetize :price
      t.string :idempotency_key
      t.integer :status, default: 0
      t.text :error, default: '{}', null: false

      t.timestamps
    end

    add_index :purchases, %i[user_id product_id]
  end
end
