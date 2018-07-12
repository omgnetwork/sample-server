class ChangeSatangColumn < ActiveRecord::Migration[5.2]
  def change
    update_price(:products)
    update_price(:purchases)
  end

  def update_price(table)
    return nil unless column_exists?(table, :price_satangs)
    rename_column(table, :price_satangs, :price_cents)
  end
end
