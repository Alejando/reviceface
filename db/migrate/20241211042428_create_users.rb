class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.timestamps
      t.references :clinic, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.date :birthdate
      t.string :role
      t.datetime :inactivated_at
    end
  end
end
