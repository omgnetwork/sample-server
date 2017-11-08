class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, index: true, unique: true
      t.string :password_digest
      t.string :first_name
      t.string :last_name
      t.timestamp :last_logged_in_at

      t.timestamps
    end
  end
end
