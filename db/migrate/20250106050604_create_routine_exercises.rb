class CreateRoutineExercises < ActiveRecord::Migration[8.0]
  def change
    create_table :routine_exercises do |t|
      t.timestamps
      t.references :routine, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true
      t.integer :repetitions
      t.integer :series
      t.integer :rest_time
      t.integer :order, default: 0
    end
  end
end
