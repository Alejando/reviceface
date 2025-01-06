class CreateRoutines < ActiveRecord::Migration[8.0]
  def change
    create_table :routines do |t|
      t.timestamps
      t.references :patient, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.datetime :start_at
      t.datetime :end_at
      t.string :status
      t.decimal :accuracy_score, precision: 19, scale: 4, null: false, default: 0
    end
  end
end
