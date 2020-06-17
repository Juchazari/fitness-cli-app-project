class CreateUsers < ActiveRecord::Migration[5.2]

  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.integer :age
      t.string :height
      t.integer :weight
      t.string :gender
      t.boolean :account_setup_complete, default: false
      t.boolean :is_logged_in, default: false
    end
  end

end
