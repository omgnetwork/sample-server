class ChangeIntegerLimitInPurchases < ActiveRecord::Migration[5.1]
  def up
    change_column :purchases, :token_value, :decimal, precision: 81, scale: 0
  end

  def down
    change_column :purchases, :token_value, :integer, limit: 4
  end
end
