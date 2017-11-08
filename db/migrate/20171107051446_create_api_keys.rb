class CreateApiKeys < ActiveRecord::Migration[5.1]
  def change
    create_table :api_keys do |t|
      t.string :key, index: true, unique: true
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
