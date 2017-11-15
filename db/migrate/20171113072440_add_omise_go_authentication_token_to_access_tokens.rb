class AddOmiseGoAuthenticationTokenToAccessTokens < ActiveRecord::Migration[5.1]
  def change
    add_column :access_tokens, :omisego_authentication_token, :string
  end
end
