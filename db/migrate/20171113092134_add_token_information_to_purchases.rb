class AddTokenInformationToPurchases < ActiveRecord::Migration[5.1]
  def change
    add_column :purchases, :token_value, :integer
    add_column :purchases, :token_symbol, :string
  end
end
