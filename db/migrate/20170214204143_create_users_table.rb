class CreateUsersTable < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password
      t.string :fname
      t.string :lname
      t.date :birthday
      t.string :city
      t.string :country
      t.text :picture
      t.timestamps
    end

  end
end
