class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :picture
      t.string :profile
      t.timestamps
    end
  end
end
