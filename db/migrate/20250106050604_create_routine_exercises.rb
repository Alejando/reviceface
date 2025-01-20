class CreateRoutineExercises < ActiveRecord::Migration[8.0]
  def change
    create_table :routine_exercises do |t|
      t.timestamps
      t.references :routine, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true
      t.integer :order, default: 0
      t.integer :series
      t.integer :repetitions
      t.integer :accuracy_score
      t.string :difficulty
      t.integer :rest_time
      t.text :feedback
      t.text :notes
      t.datetime :started_at
      t.datetime :finished_at
    end
  end
end
