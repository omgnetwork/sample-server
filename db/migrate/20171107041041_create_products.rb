class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.string :image_url
      t.monetize :price, null: false

      t.timestamps
    end
  end
end
