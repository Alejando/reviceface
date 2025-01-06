class CreateClinics < ActiveRecord::Migration[8.0]
  def change
    create_table :clinics do |t|
      t.timestamps
      t.string :name
      t.string :address
      t.string :phone
      t.string :status
      t.string :website
    end
  end
end
