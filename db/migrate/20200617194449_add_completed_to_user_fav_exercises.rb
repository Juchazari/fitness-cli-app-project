class AddCompletedToUserFavExercises < ActiveRecord::Migration[5.2]
  def change
    add_column :user_fav_exercises, :completed, :boolean, default: false
  end
end
