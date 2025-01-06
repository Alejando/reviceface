class CreatePatients < ActiveRecord::Migration[8.0]
  def change
    create_table :patients do |t|
      t.timestamps
      t.references :user, null: false, foreign_key: true
      t.references :clinic, null: false, foreign_key: true
      t.datetime :agree_terms_at
      t.datetime :agree_privacy_at
    end
  end
end
