class CreateExercises < ActiveRecord::Migration[8.0]
  def change
    create_table :exercises do |t|
      t.timestamps
      t.string :name
      t.text :description
      t.string :video_url
      t.text :objective
    end
  end
end
