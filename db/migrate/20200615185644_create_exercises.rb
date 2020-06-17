class CreateExercises < ActiveRecord::Migration[5.2]
  def change
    create_table :exercises do |t|
      t.string :name
      t.text :description
      t.integer :sets
      t.integer :reps
      t.integer :category_id
      t.integer :user_id
    end
  end
end
