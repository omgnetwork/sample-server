class CreateAccessTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :access_tokens do |t|
      t.string :token_digest
      t.references :user, foreign_key: { on_delete: :cascade }
      t.references :api_key, foreign_key: { on_delete: :cascade }
      t.timestamp :accessed_at

      t.timestamps
    end

    add_index :access_tokens, %i[user_id api_key_id], unique: true
  end
end
