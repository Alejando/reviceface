class AddGenderAndPhoneToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :gender, :string
    add_column :users, :phone, :string
  end
end
